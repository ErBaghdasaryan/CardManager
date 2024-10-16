//
//  MatchGameCollectionViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import CardManagerModel

final class MatchGameCollectionViewCell: UICollectionViewCell, IReusableView  {

    private let header = UILabel(text: "",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Semibold", size: 17))
    private let gameImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor(hex: "#121828")

        self.layer.cornerRadius = 7

        self.header.textAlignment = .center

        self.gameImage.layer.masksToBounds = true
        self.gameImage.layer.cornerRadius = 37

        self.addSubview(header)
        self.addSubview(gameImage)
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
    }
}

extension MatchGameCollectionViewCell: ISetupable {

    typealias SetupModel = GamePresentationModel

    func setup(with model: GamePresentationModel) {
        self.gameImage.image = model.gameImage
        self.header.text = model.title
        self.setupUI()
    }
}
