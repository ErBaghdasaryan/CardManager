//
//  MatchRouter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import UIKit
import CardManagerViewModel
import CardManagerModel

final class MatchRouter: BaseRouter {

    static func showAddMatchViewController(in navigationController: UINavigationController, navigationModel: SubjectNavigationModel) {
        let viewController = ViewControllerFactory.makeAddMatchViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showEditMatchViewController(in navigationController: UINavigationController, navigationModel: MatchNavigationModel) {
        let viewController = ViewControllerFactory.makeEditMatchViewController(navigationModel: navigationModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
