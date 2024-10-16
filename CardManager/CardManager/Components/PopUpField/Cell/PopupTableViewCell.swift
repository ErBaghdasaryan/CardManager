//
//  PopupTableViewCell.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import SnapKit

class PopupTableViewCell: UITableViewCell, IReusableView {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.backgroundColor = UIColor(hex: "#121828")
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(31)
        }

    }

    // MARK: - Configuration

    func configure(with text: String) {
        titleLabel.text = text
    }
}
