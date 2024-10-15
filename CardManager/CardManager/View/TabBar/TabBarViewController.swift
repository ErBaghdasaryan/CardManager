//
//  TabBarViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        lazy var gameViewController = self.createNavigation(title: "Games",
                                                            image: "game",
                                                            vc: ViewControllerFactory.makeGameViewController())

        lazy var strategyViewController = self.createNavigation(title: "Strategies",
                                                                image: "strategy",
                                                                vc: ViewControllerFactory.makeStrategyViewController())

        lazy var matchViewController = self.createNavigation(title: "Matches",
                                                             image: "match",
                                                             vc: ViewControllerFactory.makeMatchViewController())

        lazy var statisticViewController = self.createNavigation(title: "Statistics",
                                                                 image: "statistic",
                                                                 vc: ViewControllerFactory.makeStatisticViewController())

        lazy var settingsViewController = self.createNavigation(title: "Settings",
                                                                image: "settings",
                                                                vc: ViewControllerFactory.makeSettingsViewController())

        self.setViewControllers([gameViewController, strategyViewController, matchViewController, statisticViewController, settingsViewController], animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setCurrentPageToTeam), name: Notification.Name("ResetCompleted"), object: nil)

        gameViewController.delegate = self
        strategyViewController.delegate = self
        matchViewController.delegate = self
        statisticViewController.delegate = self
        settingsViewController.delegate = self
    }
    
    @objc func setCurrentPageToTeam() {
        self.selectedIndex = 0
    }

    private func createNavigation(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        self.tabBar.backgroundColor = UIColor(hex: "#121828")

        let unselectedImage = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: image)?.withTintColor(.white, renderingMode: .alwaysTemplate)

        navigation.tabBarItem.image = UIImage(named: image)
        navigation.tabBarItem.selectedImage = selectedImage
        navigation.tabBarItem.title = title

        let nonselectedTitleColor: UIColor = UIColor(hex: "#999999")!
        let selectedTitleColor: UIColor = UIColor(hex: "#094AF6")!

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: nonselectedTitleColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTitleColor
        ]

        navigation.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        navigation.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)

        self.tabBar.tintColor = UIColor(hex: "#094AF6")!
        self.tabBar.unselectedItemTintColor = UIColor(hex: "#999999")!
        self.tabBar.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.tabBar.layer.borderWidth = 1

        return navigation
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        #endif
    }
}

//MARK: Navigation & TabBar Hidden
extension TabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            self.tabBar.isHidden = true
        } else {
            self.tabBar.isHidden = false
        }
    }
}

//MARK: Preview
import SwiftUI

struct TabBarViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarViewController = TabBarViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) -> TabBarViewController {
            return tabBarViewController
        }

        func updateUIViewController(_ uiViewController: TabBarViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) {
        }
    }
}
