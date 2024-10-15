//
//  ViewControllerFactory.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Swinject
import CardManagerViewModel
import CardManagerModel

final class ViewControllerFactory {
    private static let commonAssemblies: [Assembly] = [ServiceAssembly()]

    //MARK: - UntilOnboarding
    static func makeUntilOnboardingViewController() -> UntilOnboardingViewController {
        let assembler = Assembler(commonAssemblies + [UntilOnboardingAssembly()])
        let viewController = UntilOnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IUntilOnboardingViewModel.self)
        return viewController
    }

    //MARK: Onboarding
    static func makeOnboardingViewController() -> OnboardingViewController {
        let assembler = Assembler(commonAssemblies + [OnboardingAssembly()])
        let viewController = OnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }

    //MARK: - TabBar
    static func makeTabBarViewController() -> TabBarViewController {
        let viewController = TabBarViewController()
        return viewController
    }

    //MARK: Game
    static func makeGameViewController() -> GameViewController {
        let assembler = Assembler(commonAssemblies + [GameAssembly()])
        let viewController = GameViewController()
        viewController.viewModel = assembler.resolver.resolve(IGameViewModel.self)
        return viewController
    }

    //MARK: Strategy
    static func makeStrategyViewController() -> StrategyViewController {
        let assembler = Assembler(commonAssemblies + [StrategyAssembly()])
        let viewController = StrategyViewController()
        viewController.viewModel = assembler.resolver.resolve(IStrategyViewModel.self)
        return viewController
    }

    //MARK: Match
    static func makeMatchViewController() -> MatchViewController {
        let assembler = Assembler(commonAssemblies + [MatchAssembly()])
        let viewController = MatchViewController()
        viewController.viewModel = assembler.resolver.resolve(IMatchViewModel.self)
        return viewController
    }

    //MARK: Statistic
    static func makeStatisticViewController() -> StatisticViewController {
        let assembler = Assembler(commonAssemblies + [StatisticAssembly()])
        let viewController = StatisticViewController()
        viewController.viewModel = assembler.resolver.resolve(IStatisticViewModel.self)
        return viewController
    }

    //MARK: Settings
    static func makeSettingsViewController() -> SettingsViewController {
        let assembler = Assembler(commonAssemblies + [SettingsAssembly()])
        let viewController = SettingsViewController()
        viewController.viewModel = assembler.resolver.resolve(ISettingsViewModel.self)
        return viewController
    }
}
