//
//  EmptyTableViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit

final class EmptyTableViewCell: UITableViewCell, IReusableView {
    private let header = UILabel(text: "Empty",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Semibold", size: 22))
    private let subheader = UILabel(text: "",
                                    textColor: .white.withAlphaComponent(0.7),
                                      font: UIFont(name: "SFProText-Regular", size: 13))

    private func setupUI(add what: String) {

        self.backgroundColor = UIColor(hex: "#090F1E")

        self.layer.cornerRadius = 7

        self.header.textAlignment = .center
        self.subheader.textAlignment = .center
        self.subheader.numberOfLines = 2

        self.subheader.text = "You don't have any \(what)"

        self.addSubview(header)
        self.addSubview(subheader)
        setupConstraints()
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(28)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(11)
            view.leading.equalToSuperview().offset(87)
            view.trailing.equalToSuperview().inset(87)
            view.height.equalTo(36)
        }
    }

    public func setup(with: String) {
        self.setupUI(add: with)
    }
}
