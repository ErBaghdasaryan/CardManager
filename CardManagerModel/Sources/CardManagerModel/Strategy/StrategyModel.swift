//
//  StrategyModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit

public struct StrategyModel {
    public let id: Int?
    public let gameId: Int
    public let image: UIImage
    public let strategyName: String
    public let gameName: String
    public let description: String
    public let isFavorite: Bool

    public init(id: Int? = nil, gameId: Int, image: UIImage, strategyName: String, gameName: String, description: String, isFavorite: Bool) {
        self.id = id
        self.gameId = gameId
        self.image = image
        self.strategyName = strategyName
        self.gameName = gameName
        self.description = description
        self.isFavorite = isFavorite
    }
}
