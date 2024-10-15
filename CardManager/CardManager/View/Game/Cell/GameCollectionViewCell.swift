//
//  GameCollectionViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class GameCollectionViewCell: UICollectionViewCell, IReusableView  {

    private let header = UILabel(text: "",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Semibold", size: 17))
    private let gameImage = UIImageView()
    private let playedGames = UILabel(text: "",
                                      textColor: .white,
                                      font: UIFont(name: "SFProText-Regular", size: 9))
    private let winningGames = UILabel(text: "",
                                      textColor: .white,
                                      font: UIFont(name: "SFProText-Regular", size: 9))
    private var gamesStack: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor(hex: "#094AF6")

        self.layer.cornerRadius = 7

        self.header.textAlignment = .center

        self.playedGames.backgroundColor = UIColor(hex: "#0D2549")
        self.playedGames.layer.masksToBounds = true
        self.playedGames.layer.cornerRadius = 8

        self.winningGames.backgroundColor = UIColor(hex: "#0D2549")
        self.winningGames.layer.masksToBounds = true
        self.winningGames.layer.cornerRadius = 8

        self.gameImage.layer.masksToBounds = true
        self.gameImage.layer.cornerRadius = 37

        self.addSubview(header)
        self.addSubview(gameImage)
        self.addSubview(playedGames)
        self.addSubview(winningGames)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        gameImage.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.centerX.equalToSuperview()
            view.height.equalTo(74)
            view.width.equalTo(74)
        }

        playedGames.snp.makeConstraints { view in
            view.top.equalTo(gameImage.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(9)
            view.height.equalTo(26)
            view.width.equalTo(80)
        }

        winningGames.snp.makeConstraints { view in
            view.top.equalTo(gameImage.snp.bottom).offset(12)
            view.trailing.equalToSuperview().inset(9)
            view.height.equalTo(26)
            view.width.equalTo(72)
        }
    }
}

extension GameCollectionViewCell: ISetupable {

    typealias SetupModel = GamePresentationModel

    func setup(with model: GamePresentationModel) {
        self.gameImage.image = model.gameImage
        self.header.text = model.title
        self.playedGames.text = "Played: \(model.played) times"
        self.winningGames.text = "Winning %: \(model.wins)"
        self.setupUI()
    }
}
