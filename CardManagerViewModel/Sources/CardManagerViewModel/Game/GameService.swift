//
//  GameService.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel
import SQLite

public protocol IGameService {
    func addGame(_ model: GameModel) throws -> GameModel
    func getGames() throws -> [GameModel]
    func deleteGame(byID id: Int) throws
    func editGame(_ game: GameModel) throws
}

public class GameService: IGameService {

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    public init() { }

    public func addGame(_ model: GameModel) throws -> GameModel {
        let db = try Connection("\(self.path)/db.sqlite3")
        let games = Table("Games")
        let idColumn = Expression<Int>("id")
        let imageColumn = Expression<Data>("image")
        let nameColumn = Expression<String>("name")
        let descriptionColumn = Expression<String>("description")
        let timePlayedColumn = Expression<String>("timePlayed")
        let winRateColumn = Expression<String>("winRate")

        try db.run(games.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(imageColumn)
            t.column(nameColumn)
            t.column(descriptionColumn)
            t.column(timePlayedColumn)
            t.column(winRateColumn)
        })

        guard let imageData = model.image.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        let rowId = try db.run(games.insert(
            imageColumn <- imageData,
            nameColumn <- model.header,
            descriptionColumn <- model.description,
            timePlayedColumn <- model.played,
            winRateColumn <- model.wins
        ))

        return GameModel(id: Int(rowId),
                         header: model.header,
                         image: model.image,
                         description: model.description,
                         played: model.played,
                         wins: model.wins)
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

            var fetchedGame = GameModel(id: game[idColumn],
                                        header: game[nameColumn],
                                        image: image,
                                        description: game[descriptionColumn],
                                        played: game[timePlayedColumn],
                                        wins: game[winRateColumn])
            result.append(fetchedGame)
        }

        return result
    }

    public func deleteGame(byID id: Int) throws {
        let db = try Connection("\(self.path)/db.sqlite3")
        let games = Table("Games")
        let idColumn = Expression<Int>("id")

        let gameToDelete = games.filter(idColumn == id)
        try db.run(gameToDelete.delete())
    }

    public func editGame(_ game: GameModel) throws {
        let db = try Connection("\(self.path)/db.sqlite3")
        let games = Table("Games")
        let idColumn = Expression<Int>("id")
        let imageColumn = Expression<Data>("image")
        let nameColumn = Expression<String>("name")
        let descriptionColumn = Expression<String>("description")
        let timePlayedColumn = Expression<String>("timePlayed")
        let winRateColumn = Expression<String>("winRate")

        guard let imageData = game.image.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        let gameToUpdate = games.filter(idColumn == game.id!)
        try db.run(gameToUpdate.update(
            imageColumn <- imageData,
            nameColumn <- game.header,
            descriptionColumn <- game.description,
            timePlayedColumn <- game.played,
            winRateColumn <- game.wins
        ))
    }

}
