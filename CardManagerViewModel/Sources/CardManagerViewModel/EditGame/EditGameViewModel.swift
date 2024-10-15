//
//  EditGameViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import CardManagerModel
import Combine

public protocol IEditGameViewModel {
    func editGame(_ model: GameModel)
    func deleteGame(by id: Int)
    var model: GameModel { get }
}

public class EditGameViewModel: IEditGameViewModel {

    private let gameService: IGameService
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()
    public var model: GameModel

    public init(gameService: IGameService, navigationModel: GameNavigationModel) {
        self.gameService = gameService
        self.activateSuccessSubject = navigationModel.activateSuccessSubject
        self.model = navigationModel.model
    }

    public func editGame(_ model: GameModel) {
        do {
            try self.gameService.editGame(model)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }

    public func deleteGame(by id: Int) {
        do {
            try self.gameService.deleteGame(byID: id)
            activateSuccessSubject.send(true)
        } catch {
            print(error)
        }
    }
}
