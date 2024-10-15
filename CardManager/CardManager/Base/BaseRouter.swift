//
//  BaseRouter.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import Combine
import CardManagerViewModel

class BaseRouter {

    class func popViewController(in navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
}
