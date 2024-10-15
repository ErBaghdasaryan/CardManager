//
//  UntilOnboardingAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel
import CardManagerModel

final class UntilOnboardingAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IUntilOnboardingViewModel.self, initializer: UntilOnboardingViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IUntilOnboardingService.self, initializer: UntilOnboardingService.init)
    }
}

