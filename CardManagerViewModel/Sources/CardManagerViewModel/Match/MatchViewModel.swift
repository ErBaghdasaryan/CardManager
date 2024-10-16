//
//  MatchViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IMatchViewModel {
    func loadData()
    func loadMatches()
    func editMatch(_ model: MatchModel)
    var matches: [MatchModel] { get set }
    var filteredMatches: [MatchModel] { get set }
    var games: [GameModel] { get set }
    var activateSuccessSubject: PassthroughSubject<Bool, Never> { get }
}

public class MatchViewModel: IMatchViewModel {

    private let matchService: IMatchService
    public var appStorageService: IAppStorageService
    public var games: [GameModel] = []
    public var matches: [MatchModel] = []
    public var filteredMatches: [MatchModel] = []
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(matchService: IMatchService, appStorageService: IAppStorageService) {
        self.matchService = matchService
        self.appStorageService = appStorageService
    }

    public func loadData() {
        do {
            self.games = try self.matchService.getGames()
        } catch {
            print(error)
        }
    }

    public func loadMatches() {
        do {
            self.matches = try self.matchService.getMatches()
            self.filteredMatches = matches
            calculateMatches(matches: matches)
        } catch {
            print(error)
        }
    }

    public func editMatch(_ model: MatchModel) {
        do {
            try self.matchService.editMatch(model)
        } catch {
            print(error)
        }
    }

    private func calculateMatches(matches: [MatchModel]) {
        let count = matches.count
        appStorageService.saveData(key: .matchesCount, value: "\(count)")

        var totalProfit: Double = 0.0
        var totalBet: Double = 0.0

        for match in matches {
            if let profitValue = Double(match.profit) {
                totalProfit += profitValue
            }
            if let betValue = Double(match.bet) {
                totalBet += betValue
            }
        }

        appStorageService.saveData(key: .winCount, value: "\(Int(totalProfit))")
        appStorageService.saveData(key: .loseCount, value: "\(Int(totalBet))")
    }
}
