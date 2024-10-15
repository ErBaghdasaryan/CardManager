//
//  AddGameAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel
import CardManagerModel

final class AddGameAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IAddGameViewModel.self, argument: SubjectNavigationModel.self, initializer: AddGameViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IGameService.self, initializer: GameService.init)
    }
}
