//
//  AddPhotoView.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

final class AddPhotoView: UIView {
    private let defaultImage = UIImageView(image: UIImage(named: "addImage"))
    private var image = UIImageView()

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor(hex: "#121828")

        self.layer.cornerRadius = 16

        self.image.backgroundColor = .clear
        self.image.contentMode = .scaleToFill
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 85

        addSubview(defaultImage)
        addSubview(image)
        setupConstraints()
    }

    private func setupConstraints() {
        defaultImage.snp.makeConstraints { view in
            view.centerY.equalToSuperview()
            view.centerX.equalToSuperview()
            view.width.equalTo(128)
            view.height.equalTo(32)
        }

        image.snp.makeConstraints { view in
            view.centerY.equalToSuperview()
            view.centerX.equalToSuperview()
            view.width.equalTo(189)
            view.height.equalTo(193)
        }
    }

    public func setup(with image: UIImage) {
        self.image = UIImageView(image: image)
        self.setupUI()
    }
}
