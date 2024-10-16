//
//  EditStrategyViewModel.swift
//
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IEditStrategyViewModel {
    func editStrategy(_ model: StrategyModel)
    func deleteStrategy(by id: Int)
    var model: StrategyModel { get }
    var games: [GameModel] { get set }
    func loadData()
}

public class EditStrategyViewModel: IEditStrategyViewModel {

    private let strategyService: IStrategyService
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()
    public var model: StrategyModel
    public var games: [GameModel] = []

    public init(strategyService: IStrategyService, navigationModel: StrategyNavigationModel) {
        self.strategyService = strategyService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
        self.model = navigationModel.model
    }

    public func editStrategy(_ model: StrategyModel) {
        do {
            try self.strategyService.editStrategy(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }

    public func deleteStrategy(by id: Int) {
        do {
            try self.strategyService.deleteStrategy(byID: id)
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
