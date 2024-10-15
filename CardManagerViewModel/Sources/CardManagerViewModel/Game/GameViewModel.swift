//
//  GameViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IGameViewModel {
    func loadData()
    var games: [GameModel] { get set }
    var activateSuccessSubject: PassthroughSubject<Bool, Never> { get }
}

public class GameViewModel: IGameViewModel {

    private let gameService: IGameService
    public var games: [GameModel] = []
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(gameService: IGameService) {
        self.gameService = gameService
    }

    public func loadData() {
        do {
            self.games = try self.gameService.getGames()
        } catch {
            print(error)
        }
    }
}
