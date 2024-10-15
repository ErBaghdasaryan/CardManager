//
//  OnboardingViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit

class OnboardingViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    var collectionView: UICollectionView!
    private let bottomView = UIView()
    private let header = UILabel(text: "",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 28))
    private let descriptionLabel = UILabel(text: "",
                                           textColor: .white.withAlphaComponent(0.7),
                                      font: UIFont(name: "SFProText-Regular", size: 15))
    private let continueButton = UIButton(type: .system)
    private let pageControl = AdvancedPageControlView()
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradientToBottomView()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.bottomView.layer.borderWidth = 1
        self.bottomView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        header.textAlignment = .center
        header.numberOfLines = 2

        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2

        self.continueButton.setTitle("Next", for: .normal)
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 17)
        self.continueButton.setTitleColor(.white, for: .normal)
        self.continueButton.backgroundColor = UIColor(hex: "#007AFF")

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = sizeForItem()
        mylayout.scrollDirection = .horizontal
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        setupConstraints()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 3,
                                               height: 8,
                                               width: 8,
                                               space: 10,
                                               indicatorColor: .white,
                                               dotsColor: UIColor.white.withAlphaComponent(0.2),
                                               isBordered: true,
                                               borderWidth: 0.0,
                                               indicatorBorderColor: .orange,
                                               indicatorBorderWidth: 0.0)

        collectionView.register(OnboardingCell.self)
        collectionView.backgroundColor = UIColor(hex: "#021F48")
        collectionView.isScrollEnabled = false
    }

    override func setupViewModel() {
        super.setupViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel?.loadData()
    }

    func sizeForItem() -> CGSize {
        let deviceType = UIDevice.currentDeviceType

        switch deviceType {
        case .iPhone:
            let width = self.view.frame.size.width
            let heightt = self.view.frame.size.height - 300
            return CGSize(width: width, height: heightt)
        case .iPad:
            let scaleFactor: CGFloat = 1.5
            let width = 550 * scaleFactor
            let height = 1100 * scaleFactor
            return CGSize(width: width, height: height)
        }
    }

    func setupConstraints() {
        self.view.addSubview(bottomView)
        self.view.addSubview(collectionView)
        self.view.addSubview(header)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(continueButton)
        self.view.addSubview(pageControl)

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(300)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalTo(bottomView.snp.top)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(43)
            view.leading.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().inset(24)
            view.height.equalTo(34)
        }

        descriptionLabel.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().inset(24)
            view.height.equalTo(20)
        }

        continueButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(70)
            view.leading.equalToSuperview().offset(70)
            view.trailing.equalToSuperview().inset(70)
            view.height.equalTo(50)
        }

        pageControl.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(46)
            view.leading.equalToSuperview().offset(165)
            view.trailing.equalToSuperview().inset(165)
            view.height.equalTo(8)
        }
    }

}

//MARK: Make buttons actions
extension OnboardingViewController {
    
    private func makeButtonsAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTaped), for: .touchUpInside)
    }

    @objc func continueButtonTaped() {
        guard let navigationController = self.navigationController else { return }

        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        let nextRow = self.currentIndex + 1

        if nextRow < numberOfItems {
            let nextIndexPath = IndexPath(item: nextRow, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            self.currentIndex = nextRow
        } else {
            OnboardingRouter.showTabBarViewController(in: navigationController)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if let visibleItem = visibleItems.first {
            currentIndex = visibleItem.item
        }
    }

    private func addGradientToBottomView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#090F1E")!.cgColor, UIColor(hex: "#001D69")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bottomView.bounds
        bottomView.layer.insertSublayer(gradientLayer, at: 0)

        bottomView.layer.sublayers?.first?.frame = bottomView.bounds
    }
}

extension OnboardingViewController: IViewModelableController {
    typealias ViewModel = IOnboardingViewModel
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.onboardingItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCell = collectionView.dequeueReusableCell(for: indexPath)
        descriptionLabel.text = viewModel?.onboardingItems[indexPath.row].description
        header.text = viewModel?.onboardingItems[indexPath.row].header
        cell.setup(image: viewModel?.onboardingItems[indexPath.row].image ?? "")
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let width = scrollView.frame.width

        pageControl.setPage(Int(round(offset / width)))
    }
}

//MARK: Preview
import SwiftUI

struct OnboardingViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let onboardingViewController = OnboardingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) -> OnboardingViewController {
            return onboardingViewController
        }

        func updateUIViewController(_ uiViewController: OnboardingViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) {
        }
    }
}
