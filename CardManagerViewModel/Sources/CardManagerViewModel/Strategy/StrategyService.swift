//
//  StrategyService.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel
import SQLite

public protocol IStrategyService {
    func addStrategy(_ model: StrategyModel) throws -> StrategyModel
    func getStrategies() throws -> [StrategyModel]
    func getStrategies(by gameId: Int) throws -> [StrategyModel]
    func deleteStrategy(byID id: Int) throws
    func editStrategy(_ strategy: StrategyModel) throws
    func getGames() throws -> [GameModel]
}

public class StrategyService: IStrategyService {

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    public init() { }

    public func addStrategy(_ model: StrategyModel) throws -> StrategyModel {
        let db = try Connection("\(path)/db.sqlite3")
        let strategies = Table("Strategies")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let imageColumn = Expression<Data>("image")
        let strategyNameColumn = Expression<String>("strategyName")
        let gameNameColumn = Expression<String>("gameName")
        let descriptionColumn = Expression<String>("description")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        try db.run(strategies.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(gameIdColumn)
            t.column(imageColumn)
            t.column(strategyNameColumn)
            t.column(gameNameColumn)
            t.column(descriptionColumn)
            t.column(isFavoriteColumn)
            t.foreignKey(gameIdColumn, references: Table("Games"), Expression<Int>("id"), delete: .cascade)
        })

        guard let imageData = model.image.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        let rowId = try db.run(strategies.insert(
            gameIdColumn <- model.gameId,
            imageColumn <- imageData,
            strategyNameColumn <- model.strategyName,
            gameNameColumn <- model.gameName,
            descriptionColumn <- model.description,
            isFavoriteColumn <- model.isFavorite
        ))

        return StrategyModel(id: Int(rowId),
                             gameId: model.gameId,
                             image: model.image,
                             strategyName: model.strategyName,
                             gameName: model.gameName,
                             description: model.description,
                             isFavorite: model.isFavorite)
    }

    public func getStrategies(by gameId: Int) throws -> [StrategyModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let strategies = Table("Strategies")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let imageColumn = Expression<Data>("image")
        let strategyNameColumn = Expression<String>("strategyName")
        let gameNameColumn = Expression<String>("gameName")
        let descriptionColumn = Expression<String>("description")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        var result: [StrategyModel] = []

        for strategy in try db.prepare(strategies.filter(gameIdColumn == gameId)) {
            guard let image = UIImage(data: strategy[imageColumn]) else {
                throw NSError(domain: "ImageConversionError", code: 2, userInfo: nil)
            }

            let fetchedStrategy = StrategyModel(id: strategy[idColumn],
                                                gameId: strategy[gameIdColumn],
                                                image: image,
                                                strategyName: strategy[strategyNameColumn],
                                                gameName: strategy[gameNameColumn],
                                                description: strategy[descriptionColumn],
                                                isFavorite: strategy[isFavoriteColumn])

            result.append(fetchedStrategy)
        }

        return result
    }

    public func getStrategies() throws -> [StrategyModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let strategies = Table("Strategies")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let imageColumn = Expression<Data>("image")
        let strategyNameColumn = Expression<String>("strategyName")
        let gameNameColumn = Expression<String>("gameName")
        let descriptionColumn = Expression<String>("description")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        var result: [StrategyModel] = []

        for strategy in try db.prepare(strategies) {
            guard let image = UIImage(data: strategy[imageColumn]) else {
                throw NSError(domain: "ImageConversionError", code: 2, userInfo: nil)
            }

            let fetchedStrategy = StrategyModel(id: strategy[idColumn],
                                                gameId: strategy[gameIdColumn],
                                                image: image,
                                                strategyName: strategy[strategyNameColumn],
                                                gameName: strategy[gameNameColumn],
                                                description: strategy[descriptionColumn],
                                                isFavorite: strategy[isFavoriteColumn])

            result.append(fetchedStrategy)
        }

        return result
    }

    public func deleteStrategy(byID id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let strategies = Table("Strategies")
        let idColumn = Expression<Int>("id")

        let strategyToDelete = strategies.filter(idColumn == id)
        try db.run(strategyToDelete.delete())
    }

    public func editStrategy(_ strategy: StrategyModel) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let strategies = Table("Strategies")
        let idColumn = Expression<Int>("id")
        let gameIdColumn = Expression<Int>("gameId")
        let imageColumn = Expression<Data>("image")
        let strategyNameColumn = Expression<String>("strategyName")
        let gameNameColumn = Expression<String>("gameName")
        let descriptionColumn = Expression<String>("description")
        let isFavoriteColumn = Expression<Bool>("isFavorite")

        guard let imageData = strategy.image.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        let strategyToUpdate = strategies.filter(idColumn == strategy.id!)
        try db.run(strategyToUpdate.update(
            gameIdColumn <- strategy.gameId,
            imageColumn <- imageData,
            strategyNameColumn <- strategy.strategyName,
            gameNameColumn <- strategy.gameName,
            descriptionColumn <- strategy.description,
            isFavoriteColumn <- strategy.isFavorite
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
