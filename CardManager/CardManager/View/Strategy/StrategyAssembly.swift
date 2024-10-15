//
//  StrategyAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel

final class StrategyAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IStrategyViewModel.self, initializer: StrategyViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IStrategyService.self, initializer: StrategyService.init)
    }
}
