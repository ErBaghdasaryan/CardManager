//
//  UntilOnboardingViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit

class UntilOnboardingViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let logoImage = UIImageView(image: .init(named: "appLogo"))
    private let progressLabel = UILabel(text: "",
                                        textColor: UIColor.white.withAlphaComponent(0.6),
                                        font: UIFont(name: "SFProText-Semibold", size: 17))
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var progress: Float = 1.0 {
        willSet {
            self.progressLabel.text = "\(Int(newValue))%"
        }
    }
    private var timer: Timer?
    private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startProgress()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        activityIndicator.color = UIColor.white.withAlphaComponent(0.6)

        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        self.view.addSubview(logoImage)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(progressLabel)

        logoImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(314)
            view.centerX.equalToSuperview()
            view.height.equalTo(216)
            view.width.equalTo(183)
        }

        activityIndicator.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(104)
            view.leading.equalToSuperview().offset(159)
            view.width.equalTo(30)
            view.height.equalTo(30)
        }

        progressLabel.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(108)
            view.leading.equalTo(activityIndicator.snp.trailing).offset(8)
            view.width.equalTo(54)
            view.height.equalTo(22)
        }
    }
}


extension UntilOnboardingViewController: IViewModelableController {
    typealias ViewModel = IUntilOnboardingViewModel
}

//MARK: Activity View
extension UntilOnboardingViewController {
    private func startProgress() {
        activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 0.02,
                                     target: self,
                                     selector: #selector(updateProgress),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateProgress() {
        if progress < 100 {
            progress += 1
        } else {
            timer?.invalidate()
            timer = nil
            activityIndicator.stopAnimating()
            goToNextPage()
        }
    }

    func goToNextPage() {
        guard let navigationController = self.navigationController else { return }
        guard var viewModel = self.viewModel else { return }
        if viewModel.appStorageService.hasData(for: .skipOnboarding) {
            UntilOnboardingRouter.showTabBarViewController(in: navigationController)
        } else {
            viewModel.skipOnboarding = true
            UntilOnboardingRouter.showOnboardingViewController(in: navigationController)
        }
    }

}

//MARK: Preview
import SwiftUI

struct UntilOnboardingViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let untilOnboardingViewController = UntilOnboardingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UntilOnboardingViewControllerProvider.ContainerView>) -> UntilOnboardingViewController {
            return untilOnboardingViewController
        }

        func updateUIViewController(_ uiViewController: UntilOnboardingViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UntilOnboardingViewControllerProvider.ContainerView>) {
        }
    }
}
