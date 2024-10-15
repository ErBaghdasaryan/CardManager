//
//  MatchStat.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class MatchStat: UIView {
    private let statImage = UIImageView()
    private let header = UILabel(text: "",
                                 textColor: UIColor(hex: "#656565")!,
                                 font: UIFont(name: "SFProText-Regular", size: 10))
    private let count = UILabel(text: "",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 17))
    private var state: MatchOrRate!

    public init(matchOrRate: MatchOrRate) {
        super.init(frame: .zero)
        self.state = matchOrRate
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor(hex: "#121828")
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1

        self.header.textAlignment = .left
        self.layer.cornerRadius = 8

        self.count.textAlignment = .left
        self.statImage.image = UIImage(named: "matchIcon")

        switch state {
        case .match:
            self.statImage.isHidden = true
            self.header.text = "Matches"
        case .rate:
            self.statImage.isHidden = false
            self.header.text = "Win-rate, %"
        case .none:
            break
        }

        self.count.text = "--------"

        addSubview(statImage)
        addSubview(header)
        addSubview(count)
        setupConstraints()
    }

    private func setupConstraints() {

        statImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(17)
            view.trailing.equalToSuperview().inset(10)
            view.width.equalTo(20)
            view.height.equalTo(22)
        }

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(10)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().inset(84)
            view.height.equalTo(16)
        }

        count.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().inset(84)
            view.height.equalTo(22)
        }
    }

    public func setup(matchesOrRate: String) {
        self.count.text = matchesOrRate
    }
}

enum MatchOrRate {
    case match
    case rate
}
