//
//  AddGameViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IAddGameViewModel {
    func addGame(_ model: GameModel)
}

public class AddGameViewModel: IAddGameViewModel {

    private let gameService: IGameService
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(gameService: IGameService, navigationModel: SubjectNavigationModel) {
        self.gameService = gameService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
    }

    public func addGame(_ model: GameModel) {
        do {
            _ = try self.gameService.addGame(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }
}
