//
//  StrategyViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel

public protocol IStrategyViewModel {
    
}

public class StrategyViewModel: IStrategyViewModel {

    private let strategyService: IStrategyService

    public init(strategyService: IStrategyService) {
        self.strategyService = strategyService
    }
}
