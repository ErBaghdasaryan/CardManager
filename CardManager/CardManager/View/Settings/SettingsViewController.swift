//
//  SettingsViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class SettingsViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?
    private var buttonStack: UIStackView!
    private var resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 0

        self.buttonStack.addArrangedSubview(createButton(imageName: "usage",
                                                         title: "Usage Policy",
                                                         action: #selector(usageTapped), position: 1))
        self.buttonStack.addArrangedSubview(createButton(imageName: "share",
                                                         title: "Share App",
                                                         action: #selector(shareTapped), position: 2))
        self.buttonStack.addArrangedSubview(createButton(imageName: "rate",
                                                         title: "Rate Us",
                                                         action: #selector(rateTapped), position: 3))

        self.resetButton.backgroundColor = UIColor(hex: "#39CC76")
        self.resetButton.layer.cornerRadius = 12
        self.resetButton.setTitle("Reset progress", for: .normal)
        self.resetButton.setTitleColor(.white, for: .normal)

        self.view.addSubview(buttonStack)
        self.view.addSubview(resetButton)
        setupConstraints()
        makeButtonActions()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        buttonStack.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(166)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(168)
        }

        resetButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(100)
            view.leading.equalToSuperview().offset(90)
            view.trailing.equalToSuperview().inset(90)
            view.height.equalTo(50)
        }
    }
}


extension SettingsViewController: IViewModelableController {
    typealias ViewModel = ISettingsViewModel
}

//MARK: Button Actions
extension SettingsViewController {
    private func makeButtonActions() {
        self.resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
    }

    private func createButton(imageName: String,
                      title: String,
                      action: Selector,
                      position: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        button.contentHorizontalAlignment = .left

        let icon = UIImage(named: imageName)
        button.setImage(icon, for: .normal)
        button.tintColor = .white

        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        button.backgroundColor = UIColor(hex: "#121828")

        if position == 1 {
            button.layer.cornerRadius = 20
            button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if position == 3 {
            button.layer.cornerRadius = 20
            button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }

        button.addTarget(self, action: action, for: .touchUpInside)

        return button
    }

    @objc func shareTapped() {
        let appStoreURL = URL(string: "https://apps.apple.com/app/cipherharmonic/id6698865168")!

        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .openInIBooks,
            .markupAsPDF
        ]

        present(activityViewController, animated: true, completion: nil)
    }

    @objc func rateTapped() {
        guard let scene = view.window?.windowScene else { return }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview()
        } else {
            let alertController = UIAlertController(
                title: "Enjoying the app?",
                message: "Please consider leaving us a review in the App Store!",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Go to App Store", style: .default) { _ in
                if let appStoreURL = URL(string: "https://apps.apple.com/app/cipherharmonic/id6698865168") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            })
            present(alertController, animated: true, completion: nil)
        }
    }

    @objc func usageTapped() {
//        guard let navigationController = self.navigationController else { return }
//        SettingsRouter.showUsageViewController(in: navigationController)
    }

    @objc func resetTapped() {
        print("Hello")
    }
}

//MARK: Preview
import SwiftUI

struct SettingsViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let settingsViewController = SettingsViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) -> SettingsViewController {
            return settingsViewController
        }

        func updateUIViewController(_ uiViewController: SettingsViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) {
        }
    }
}
