//
//  StrategyTableViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import SnapKit
import CardManagerViewModel
import Combine

final class StrategyTableViewCell: UITableViewCell, IReusableView {

    private let content = UIView()

    private let strategyImage = UIImageView()
    private let title = UILabel(text: "",
                                textColor: UIColor(hex: "#696969")!,
                                font: UIFont(name: "SFProText-Regular", size: 13))
    private let strategyName = UILabel(text: "",
                                       textColor: .white,
                                font: UIFont(name: "SFProText-Semibold", size: 17))
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

        self.title.textAlignment = .left
        self.strategyName.textAlignment = .left

        self.strategyImage.layer.cornerRadius = 25
        self.strategyImage.backgroundColor = .clear
        self.strategyImage.contentMode = .scaleToFill
        self.strategyImage.layer.masksToBounds = true

        self.isTapped = false

        addSubview(content)
        self.content.addSubview(strategyImage)
        self.content.addSubview(title)
        self.content.addSubview(strategyName)
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

        strategyImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.width.equalTo(50)
            view.height.equalTo(50)
        }

        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(17)
            view.leading.equalTo(strategyImage.snp.trailing).offset(10)
            view.trailing.equalToSuperview().inset(22)
            view.height.equalTo(18)
        }

        strategyName.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(2)
            view.leading.equalTo(strategyImage.snp.trailing).offset(10)
            view.trailing.equalToSuperview().inset(22)
            view.height.equalTo(20)
        }

        noteType.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(25)
            view.trailing.equalToSuperview().inset(12)
            view.width.equalTo(24)
            view.height.equalTo(24)
        }
    }

    public func setup(strategyImage: UIImage,
                      title: String,
                      strategyName: String,
                      isFavorite: Bool) {
        self.strategyImage.image = strategyImage
        self.title.text = title
        self.isTapped = isFavorite
        self.strategyName.text = strategyName
        self.setupUI()
    }
}

extension StrategyTableViewCell {
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
