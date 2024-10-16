//
//  EditMatchViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IEditMatchViewModel {
    func loadData()
    func deleteMatch(by id: Int)
    func editMatch(model: MatchModel)
    var match: MatchModel { get set }
    var games: [GameModel] { get set }
}

public class EditMatchViewModel: IEditMatchViewModel {

    private let matchService: IMatchService
    public var match: MatchModel
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()
    public var games: [GameModel] = []

    public init(matchService: IMatchService, navigationModel: MatchNavigationModel) {
        self.matchService = matchService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
        self.match = navigationModel.model
    }

    public func editMatch(model: MatchModel) {
        do {
            try self.matchService.editMatch(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }

    public func loadData() {
        do {
            self.games = try self.matchService.getGames()
        } catch {
            print(error)
        }
    }

    public func deleteMatch(by id: Int) {
        do {
            try self.matchService.deleteMatch(byID: id)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }
}
