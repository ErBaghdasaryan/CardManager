//
//  GameModel.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit

public struct GameModel {
    public let id: Int?
    public let header: String
    public let image: UIImage
    public let description: String
    public let played: String
    public let wins: String

    public init(id: Int? = nil, header: String, image: UIImage, description: String, played: String, wins: String) {
        self.id = id
        self.header = header
        self.image = image
        self.description = description
        self.played = played
        self.wins = wins
    }
}
