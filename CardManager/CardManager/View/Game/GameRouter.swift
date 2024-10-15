//
//  GameRouter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import UIKit
import CardManagerViewModel
import CardManagerModel

final class GameRouter: BaseRouter {

    static func showAddGameViewController(in navigationController: UINavigationController, navigationModel: SubjectNavigationModel) {
        let viewController = ViewControllerFactory.makeAddGameViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showEditGameViewController(in navigationController: UINavigationController, navigationModel: GameNavigationModel) {
        let viewController = ViewControllerFactory.makeEditGameViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
