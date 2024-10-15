//
//  MostPlayed.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class MostPlayed: UIView {

    private let statImage = UIImageView()
    private var isPlayed: Bool!

    public init(isPlayed: Bool) {
        super.init(frame: .zero)
        self.isPlayed = isPlayed
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor(hex: "#121828")
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8

        if isPlayed {
            self.statImage.image = UIImage(named: "mostPlayedKnown")
        } else {
            self.statImage.image = UIImage(named: "mostPlayedUnknown")
        }

        addSubview(statImage)
        setupConstraints()
    }

    private func setupConstraints() {

        statImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(65)
            view.trailing.equalToSuperview().inset(63)
            view.width.equalTo(232)
            view.height.equalTo(232)
        }
    }

    public func setup(isPlayed: Bool) {
        self.isPlayed = isPlayed
        self.setupUI()
    }
}
