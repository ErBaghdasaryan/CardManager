//
//  StrategyViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IStrategyViewModel {
    func loadData()
    func editStrategy(_ model: StrategyModel)
    var strategies: [StrategyModel] { get set }
    var filteredStrategies: [StrategyModel] { get set }
    var activateSuccessSubject: PassthroughSubject<Bool, Never> { get }
}

public class StrategyViewModel: IStrategyViewModel {

    private let strategyService: IStrategyService
    public var strategies: [StrategyModel] = []
    public var filteredStrategies: [StrategyModel] = []
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(strategyService: IStrategyService) {
        self.strategyService = strategyService
    }

    public func loadData() {
        do {
            self.strategies = try self.strategyService.getStrategies()
            self.filteredStrategies = strategies
        } catch {
            print(error)
        }
    }

    public func editStrategy(_ model: StrategyModel) {
        do {
            try self.strategyService.editStrategy(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }
}
