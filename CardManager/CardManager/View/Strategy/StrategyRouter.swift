//
//  StrategyRouter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import UIKit
import CardManagerViewModel
import CardManagerModel

final class StrategyRouter: BaseRouter {

    static func showAddStrategyViewController(in navigationController: UINavigationController, navigationModel: SubjectNavigationModel) {
        let viewController = ViewControllerFactory.makeAddStrategyViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showEditStrategyViewController(in navigationController: UINavigationController, navigationModel: StrategyNavigationModel) {
        let viewController = ViewControllerFactory.makeEditStrategyViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
