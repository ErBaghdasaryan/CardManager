//
//  MatchModel.swift
//
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit

public struct MatchModel {
    public let id: Int?
    public let gameId: Int
    public let name: String
    public let players: String
    public let date: String
    public let status: String
    public let profit: String
    public let bet: String
    public let isFavorite: Bool

    public init(id: Int? = nil, gameId: Int, name: String, players: String, date: String, status: String, profit: String, bet: String, isFavorite: Bool) {
        self.id = id
        self.gameId = gameId
        self.name = name
        self.players = players
        self.date = date
        self.status = status
        self.profit = profit
        self.bet = bet
        self.isFavorite = isFavorite
    }
}
