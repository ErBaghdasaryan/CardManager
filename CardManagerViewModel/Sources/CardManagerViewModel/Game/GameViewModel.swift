//
//  GameViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel

public protocol IGameViewModel {
    
}

public class GameViewModel: IGameViewModel {

    private let gameService: IGameService

    public init(gameService: IGameService) {
        self.gameService = gameService
    }
}
