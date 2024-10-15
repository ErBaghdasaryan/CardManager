//
//  StatisticViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel

public protocol IStatisticViewModel {
    
}

public class StatisticViewModel: IStatisticViewModel {

    private let statisticService: IStatisticService

    public init(statisticService: IStatisticService) {
        self.statisticService = statisticService
    }
}
