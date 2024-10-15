//
//  GameTab.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class GameTab: UIView {
    private let header = UILabel(text: "",
                                 textColor: UIColor(hex: "#AFC0FF")!,
                                 font: UIFont(name: "SFProText-Regular", size: 13))
    private let count = UILabel(text: "-----",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 22))

    public init(title: String) {
        super.init(frame: .zero)
        self.header.text = title
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        applyGradientBackground()

        self.header.textAlignment = .left
        self.layer.cornerRadius = 10

        self.count.textAlignment = .left

        addSubview(header)
        addSubview(count)
        setupConstraints()
    }

    private func setupConstraints() {

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(80)
            view.height.equalTo(18)
        }

        count.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(4)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(70)
            view.height.equalTo(26)
        }
    }

    private func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#4181FF")!.cgColor,
            UIColor(hex: "#0350E6")!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0287, 0.9687]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 10

        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    public func setup(count: String) {
        self.count.text = count
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
}
