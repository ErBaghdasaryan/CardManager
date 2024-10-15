//
//  EditGameAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel
import CardManagerModel

final class EditGameAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IEditGameViewModel.self, argument: GameNavigationModel.self, initializer: EditGameViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IGameService.self, initializer: GameService.init)
    }
}
