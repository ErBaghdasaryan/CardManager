//
//  AddMatchAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel
import CardManagerModel

final class AddMatchAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IAddMatchViewModel.self, argument: SubjectNavigationModel.self, initializer: AddMatchViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IMatchService.self, initializer: MatchService.init)
    }
}
