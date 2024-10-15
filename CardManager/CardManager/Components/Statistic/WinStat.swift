//
//  WinStat.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class WinStat: UIView {
    private let statImage = UIImageView()
    private let header = UILabel(text: "",
                                 textColor: UIColor(hex: "#656565")!,
                                 font: UIFont(name: "SFProText-Regular", size: 10))
    private let count = UILabel(text: "",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 17))
    private let procentLabel = UILabel(text: "",
                                       textColor: UIColor(hex: "#AFF41C")!,
                                       font: UIFont(name: "SFProText-Regular", size: 9))
    private var state: ProfitOrLose!

    public init(winOrLose: ProfitOrLose) {
        super.init(frame: .zero)
        self.state = winOrLose
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
        self.procentLabel.textAlignment = .center

        self.procentLabel.layer.masksToBounds = true
        self.procentLabel.layer.cornerRadius = 8
        self.procentLabel.backgroundColor = UIColor(hex: "#313137")
        self.procentLabel.layer.borderWidth = 1
        self.procentLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor

        switch state {
        case .profit:
            self.statImage.image = UIImage(named: "winIcon")
            self.procentLabel.textColor = UIColor(hex: "#AFF41C")!
            self.header.text = "Profit"
        case .lose:
            self.statImage.image = UIImage(named: "loseIcon")
            self.procentLabel.textColor = UIColor(hex: "#FF4646")!
            self.header.text = "Loses"
        case .none:
            break
        }

        self.count.text = "--------"
        self.procentLabel.text = "-----"

        addSubview(statImage)
        addSubview(header)
        addSubview(count)
        addSubview(procentLabel)
        setupConstraints()
    }

    private func setupConstraints() {

        statImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(10)
            view.leading.equalToSuperview().offset(10)
            view.width.equalTo(20)
            view.height.equalTo(22)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(statImage.snp.bottom).offset(7)
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

        procentLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12.5)
            view.trailing.equalToSuperview().inset(10)
            view.width.equalTo(33)
            view.height.equalTo(17)
        }
    }

    public func setup(count: String) {
        switch state {
        case .profit:
            self.procentLabel.text = "+32%"
            self.count.text = "+ $\(count)"
        case .lose:
            self.procentLabel.text = "+12%"
            self.count.text = "- $\(count)"
        case .none:
            break
        }
    }
}

enum ProfitOrLose {
    case profit
    case lose
}
