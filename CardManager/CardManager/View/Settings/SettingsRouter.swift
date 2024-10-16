//
//  SettingsRourter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import UIKit
import CardManagerViewModel

final class SettingsRouter: BaseRouter {
    static func showUsageViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeUsageViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
