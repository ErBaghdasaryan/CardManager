//
//  EditStrategyAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel
import CardManagerModel

final class EditStrategyAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IEditStrategyViewModel.self, argument: StrategyNavigationModel.self, initializer: EditStrategyViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IStrategyService.self, initializer: StrategyService.init)
    }
}
