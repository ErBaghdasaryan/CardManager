//
//  Setupable.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
