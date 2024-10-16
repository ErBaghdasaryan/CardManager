//
//  MatchService.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel
import SQLite

public protocol IMatchService {
    func addMatch(_ model: MatchModel) throws -> MatchModel
    func getMatches() throws -> [MatchModel]
    func getMatches(by gameId: Int) throws -> [MatchModel]
    func deleteMatch(byID id: Int) throws
    func editMatch(_ match: MatchModel) throws
    func getGames() throws -> [GameModel]
}

public class MatchService: IMatchService {

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    public init() { }

    public func addMatch(_ model: MatchModel) throws -> MatchModel {
        let db = try Connection("\(path)/db.sqlite3")
        let matches = Table("Matches")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let nameColumn = Expression<String>("name")
        let playersColumn = Expression<String>("players")
        let dateColumn = Expression<String>("date")
        let statusColumn = Expression<String>("status")
        let profitColumn = Expression<String>("profit")
        let betColumn = Expression<String>("bet")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        try db.run(matches.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(gameIdColumn)
            t.column(nameColumn)
            t.column(playersColumn)
            t.column(dateColumn)
            t.column(statusColumn)
            t.column(profitColumn)
            t.column(betColumn)
            t.column(isFavoriteColumn)
            t.foreignKey(gameIdColumn, references: Table("Games"), Expression<Int>("id"), delete: .cascade)
        })

        let rowId = try db.run(matches.insert(
            gameIdColumn <- model.gameId,
            nameColumn <- model.name,
            playersColumn <- model.players,
            dateColumn <- model.date,
            statusColumn <- model.status,
            profitColumn <- model.profit,
            betColumn <- model.bet,
            isFavoriteColumn <- model.isFavorite
        ))

        return MatchModel(id: Int(rowId),
                          gameId: model.gameId,
                          name: model.name,
                          players: model.players,
                          date: model.date,
                          status: model.status,
                          profit: model.profit,
                          bet: model.bet,
                          isFavorite: model.isFavorite)
    }

    public func getMatches(by gameId: Int) throws -> [MatchModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let matches = Table("Matches")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let nameColumn = Expression<String>("name")
        let playersColumn = Expression<String>("players")
        let dateColumn = Expression<String>("date")
        let statusColumn = Expression<String>("status")
        let profitColumn = Expression<String>("profit")
        let betColumn = Expression<String>("bet")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        var result: [MatchModel] = []

        for match in try db.prepare(matches.filter(gameIdColumn == gameId)) {

            var fetchedMatch = MatchModel(id: match[idColumn],
                                          gameId: match[gameIdColumn],
                                          name: match[nameColumn],
                                          players: match[playersColumn],
                                          date: match[dateColumn],
                                          status: match[statusColumn],
                                          profit: match[profitColumn],
                                          bet: match[betColumn],
                                          isFavorite: match[isFavoriteColumn])

            result.append(fetchedMatch)
        }

        return result
    }

    public func getMatches() throws -> [MatchModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let matches = Table("Matches")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let nameColumn = Expression<String>("name")
        let playersColumn = Expression<String>("players")
        let dateColumn = Expression<String>("date")
        let statusColumn = Expression<String>("status")
        let profitColumn = Expression<String>("profit")
        let betColumn = Expression<String>("bet")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        var result: [MatchModel] = []

        for match in try db.prepare(matches) {

            var fetchedMatch = MatchModel(id: match[idColumn],
                                          gameId: match[gameIdColumn],
                                          name: match[nameColumn],
                                          players: match[playersColumn],
                                          date: match[dateColumn],
                                          status: match[statusColumn],
                                          profit: match[profitColumn],
                                          bet: match[betColumn],
                                          isFavorite: match[isFavoriteColumn])

            result.append(fetchedMatch)
        }

        return result
    }

    public func deleteMatch(byID id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let matches = Table("Matches")
        let idColumn = Expression<Int>("id")

        let matchToDelete = matches.filter(idColumn == id)
        try db.run(matchToDelete.delete())
    }

    public func editMatch(_ match: MatchModel) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let matches = Table("Matches")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let nameColumn = Expression<String>("name")
        let playersColumn = Expression<String>("players")
        let dateColumn = Expression<String>("date")
        let statusColumn = Expression<String>("status")
        let profitColumn = Expression<String>("profit")
        let betColumn = Expression<String>("bet")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        let matchToUpdate = matches.filter(idColumn == match.id!)
        try db.run(matchToUpdate.update(
            gameIdColumn <- match.gameId,
            nameColumn <- match.name,
            playersColumn <- match.players,
            dateColumn <- match.date,
            statusColumn <- match.status,
            profitColumn <- match.profit,
            betColumn <- match.bet,
            isFavoriteColumn <- match.isFavorite
        ))
    }

    public func getGames() throws -> [GameModel] {
        let db = try Connection("\(self.path)/db.sqlite3")
        let games = Table("Games")
        let idColumn = Expression<Int>("id")
        let imageColumn = Expression<Data>("image")
        let nameColumn = Expression<String>("name")
        let descriptionColumn = Expression<String>("description")
        let timePlayedColumn = Expression<String>("timePlayed")
        let winRateColumn = Expression<String>("winRate")

        var result: [GameModel] = []

        for game in try db.prepare(games) {
            guard let image = UIImage(data: game[imageColumn]) else {
                throw NSError(domain: "ImageConversionError", code: 2, userInfo: nil)
            }

            let fetchedGame = GameModel(id: game[idColumn],
                                        header: game[nameColumn],
                                        image: image,
                                        description: game[descriptionColumn],
                                        played: game[timePlayedColumn],
                                        wins: game[winRateColumn])
            result.append(fetchedGame)
        }

        return result
    }

}
