//
//  StatisticViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IStatisticViewModel {
    var matchesCount: String { get }
    var profit: String { get }
    var bet: String { get }
}

public class StatisticViewModel: IStatisticViewModel {

    private let statisticService: IStatisticService
    public var appStorageService: IAppStorageService

    public var matchesCount: String {
        get {
            return appStorageService.getData(key: .matchesCount) ?? "-------"
        }
    }

    public var profit: String {
        get {
            return appStorageService.getData(key: .winCount) ?? "-------"
        }
    }

    public var bet: String {
        get {
            return appStorageService.getData(key: .loseCount) ?? "-------"
        }
    }

    public init(statisticService: IStatisticService, appStorageService: IAppStorageService) {
        self.statisticService = statisticService
        self.appStorageService = appStorageService
    }
}

