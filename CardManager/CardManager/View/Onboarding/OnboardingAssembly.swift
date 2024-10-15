//
//  OnboardingAssembly.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import CardManagerViewModel

final class OnboardingAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IOnboardingViewModel.self, initializer: OnboardingViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IOnboardingService.self, initializer: OnboardingService.init)
    }
}
