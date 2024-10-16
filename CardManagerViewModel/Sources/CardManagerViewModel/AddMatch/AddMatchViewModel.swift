//
//  AddMatchViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IAddMatchViewModel {
    func loadData()
    func addMatch(model: MatchModel)
    var games: [GameModel] { get set }
}

public class AddMatchViewModel: IAddMatchViewModel {

    private let matchService: IMatchService
    public var games: [GameModel] = []
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(matchService: IMatchService, navigationModel: SubjectNavigationModel) {
        self.matchService = matchService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
    }

    public func loadData() {
        do {
            self.games = try self.matchService.getGames()
        } catch {
            print(error)
        }
    }

    public func addMatch(model: MatchModel) {
        do {
            _ = try self.matchService.addMatch(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }
}
