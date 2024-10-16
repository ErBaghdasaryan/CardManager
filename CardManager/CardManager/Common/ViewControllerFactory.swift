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

    static func makeAddGameViewController(navigationModel: SubjectNavigationModel) -> AddGameViewController {
        let assembler = Assembler(commonAssemblies + [AddGameAssembly()])
        let viewController = AddGameViewController()
        viewController.viewModel = assembler.resolver.resolve(IAddGameViewModel.self,
                                                              argument: navigationModel)
        return viewController
    }

    static func makeEditGameViewController(navigationModel: GameNavigationModel) -> EditGameViewController {
        let assembler = Assembler(commonAssemblies + [EditGameAssembly()])
        let viewController = EditGameViewController()
        viewController.viewModel = assembler.resolver.resolve(IEditGameViewModel.self,
                                                              argument: navigationModel)
        return viewController
    }

    //MARK: Strategy
    static func makeStrategyViewController() -> StrategyViewController {
        let assembler = Assembler(commonAssemblies + [StrategyAssembly()])
        let viewController = StrategyViewController()
        viewController.viewModel = assembler.resolver.resolve(IStrategyViewModel.self)
        return viewController
    }

    static func makeAddStrategyViewController(navigationModel: SubjectNavigationModel) -> AddStrategyViewController {
        let assembler = Assembler(commonAssemblies + [AddStrategyAssembly()])
        let viewController = AddStrategyViewController()
        viewController.viewModel = assembler.resolver.resolve(IAddStrategyViewModel.self,
                                                              argument: navigationModel)
        return viewController
    }

    static func makeEditStrategyViewController(navigationModel: StrategyNavigationModel) -> EditStrategyViewController {
        let assembler = Assembler(commonAssemblies + [EditStrategyAssembly()])
        let viewController = EditStrategyViewController()
        viewController.viewModel = assembler.resolver.resolve(IEditStrategyViewModel.self,
                                                              argument: navigationModel)
        return viewController
    }

    //MARK: Match
    static func makeMatchViewController() -> MatchViewController {
        let assembler = Assembler(commonAssemblies + [MatchAssembly()])
        let viewController = MatchViewController()
        viewController.viewModel = assembler.resolver.resolve(IMatchViewModel.self)
        return viewController
    }

    static func makeAddMatchViewController(navigationModel: SubjectNavigationModel) -> AddMatchViewController {
        let assembler = Assembler(commonAssemblies + [AddMatchAssembly()])
        let viewController = AddMatchViewController()
        viewController.viewModel = assembler.resolver.resolve(IAddMatchViewModel.self,
                                                              argument: navigationModel)
        return viewController
    }

    static func makeEditMatchViewController(navigationModel: MatchNavigationModel) -> EditMatchViewController {
        let assembler = Assembler(commonAssemblies + [EditMatchAssembly()])
        let viewController = EditMatchViewController()
        viewController.viewModel = assembler.resolver.resolve(IEditMatchViewModel.self,
                                                              argument: navigationModel)
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

    static func makeUsageViewController() -> UsageViewController {
        let viewController = UsageViewController()
        return viewController
    }
}
