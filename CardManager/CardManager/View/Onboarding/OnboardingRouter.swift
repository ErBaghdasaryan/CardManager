//
//  OnboardingRouter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import UIKit
import CardManagerViewModel

final class OnboardingRouter: BaseRouter {
    static func showTabBarViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeTabBarViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
