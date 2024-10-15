//
//  MatchAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel

final class MatchAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IMatchViewModel.self, initializer: MatchViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IMatchService.self, initializer: MatchService.init)
    }
}
