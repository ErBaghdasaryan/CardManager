//
//  PlayedMatchTableViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import SnapKit
import CardManagerViewModel
import Combine

final class PlayedMatchTableViewCell: UITableViewCell, IReusableView {

    private let content = UIView()

    private let date = UILabel(text: "",
                                textColor: UIColor(hex: "#787878")!,
                                font: UIFont(name: "SFProText-Regular", size: 11))
    private let winOrLose = UILabel(text: "",
                                    textColor: UIColor.white,
                                    font: UIFont(name: "SFProText-Regular", size: 13))
    private let amount = UILabel(text: "",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Regular", size: 15))
    private let bet = UILabel(text: "",
                              textColor: UIColor(hex: "#0A77FF")!,
                              font: UIFont(name: "SFProText-Regular", size: 11))
    private let players = UILabel(text: "",
                                  textColor: UIColor(hex: "#0A77FF")!,
                                  font: UIFont(name: "SFProText-Regular", size: 11))
    private let noteType = UIButton(type: .system)

    public var isTapped: Bool = false {
        didSet {
            if oldValue {
                noteType.setImage(UIImage(named: "selected"), for: .normal)
            } else {
                noteType.setImage(UIImage(named: "nonSelected"), for: .normal)
            }
        }
    }

    public var selectedSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.content.backgroundColor = UIColor(hex: "#121828")
        self.content.layer.cornerRadius = 7
        self.content.layer.borderWidth = 1
        self.content.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        self.date.textAlignment = .left
        self.amount.textAlignment = .left

        bet.backgroundColor = UIColor(hex: "#0A77FF")?.withAlphaComponent(0.12)
        bet.layer.cornerRadius = 8
        bet.layer.masksToBounds = true

        players.backgroundColor = UIColor(hex: "#0A77FF")?.withAlphaComponent(0.12)
        players.layer.cornerRadius = 8
        players.layer.masksToBounds = true

        self.isTapped = false

        addSubview(content)
        self.content.addSubview(date)
        self.content.addSubview(winOrLose)
        self.content.addSubview(amount)
        self.content.addSubview(bet)
        self.content.addSubview(players)
        self.content.addSubview(noteType)
        setupConstraints()
        makeButtonActions()
    }

    private func setupConstraints() {

        content.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(6)
            view.leading.equalToSuperview().offset(3)
            view.trailing.equalToSuperview().inset(3)
            view.bottom.equalToSuperview().inset(6)
        }

        date.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(187)
            view.height.equalTo(20)
        }

        winOrLose.snp.makeConstraints { view in
            view.top.equalTo(date.snp.bottom).offset(2)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(51)
            view.height.equalTo(20)
        }

        amount.snp.makeConstraints { view in
            view.top.equalTo(date.snp.bottom).offset(2)
            view.leading.equalTo(winOrLose.snp.trailing).offset(8)
            view.trailing.equalToSuperview().inset(150)
            view.height.equalTo(20)
        }

        bet.snp.makeConstraints { view in
            view.top.equalTo(winOrLose.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(70)
            view.height.equalTo(26)
        }

        players.snp.makeConstraints { view in
            view.top.equalTo(winOrLose.snp.bottom).offset(12)
            view.leading.equalTo(bet.snp.trailing).offset(10)
            view.width.equalTo(70)
            view.height.equalTo(26)
        }

        noteType.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(40)
            view.trailing.equalToSuperview().inset(12)
            view.width.equalTo(24)
            view.height.equalTo(24)
        }
    }

    public func setup(date: String,
                      winOrLose: String,
                      amount: String,
                      bet: String,
                      players: String,
                      isFavorite: Bool) {
        self.date.text = date
        self.amount.text = "Amount: $\(amount)"
        self.bet.text = "Bet: $\(bet)"
        self.players.text = "Players: \(bet)"
        self.isTapped = isFavorite
        if winOrLose.uppercased() == "WIN" {
            self.winOrLose.layer.cornerRadius = 5
            self.winOrLose.layer.masksToBounds = true
            self.winOrLose.backgroundColor = UIColor(hex: "#11B555")
            self.winOrLose.text = "WIN"
        } else {
            self.winOrLose.layer.cornerRadius = 5
            self.winOrLose.layer.masksToBounds = true
            self.winOrLose.backgroundColor = UIColor(hex: "#D14545")
            self.winOrLose.text = "LOSE"
        }
        self.setupUI()
    }
}

extension PlayedMatchTableViewCell {
    private func makeButtonActions() {
        self.noteType.addTarget(self, action: #selector(selected), for: .touchUpInside)
    }

    @objc func selected() {
        if isTapped {
            self.isTapped = false
        } else {
            self.isTapped = true
        }
        self.selectedSubject.send(true)
    }
}
