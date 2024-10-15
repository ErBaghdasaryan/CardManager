//
//  GamePresentationModel.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit

public struct GamePresentationModel {
    public let gameImage: UIImage
    public let title: String
    public let played: String
    public let wins: String

    public init(gameImage: UIImage, title: String, played: String, wins: String) {
        self.gameImage = gameImage
        self.title = title
        self.played = played
        self.wins = wins
    }
}
