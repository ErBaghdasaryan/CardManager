//
//  AddStrategyViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IAddStrategyViewModel {
    func addStrategy(_ model: StrategyModel)
    func loadData()
    var games: [GameModel] { get set }
}

public class AddStrategyViewModel: IAddStrategyViewModel {

    private let strategyService: IStrategyService
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()
    public var games: [GameModel] = []

    public init(strategyService: IStrategyService, navigationModel: SubjectNavigationModel) {
        self.strategyService = strategyService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
    }

    public func addStrategy(_ model: StrategyModel) {
        do {
            _ = try self.strategyService.addStrategy(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }

    public func loadData() {
        do {
            self.games = try self.strategyService.getGames()
        } catch {
            print(error)
        }
    }
}
