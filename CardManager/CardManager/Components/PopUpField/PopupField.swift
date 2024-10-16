//
//  PopupField.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import SnapKit
import CardManagerModel

public class PopupField: UIView {

    // MARK: - Properties

    public var textField: TextFieldWImage
    public var tableView: UITableView
    private var items: [GameModel]

    public var didSelectItem: ((String) -> Void)?
    public var didTapAddButton: (() -> Void)?

    private var heightConstraint: Constraint?

    // MARK: - Initializer

    public init(placeholder: String, items: [GameModel]) {
        self.textField = TextFieldWImage(placeholder: placeholder, leftImage: UIImage(named: "chevronRight"))
        self.tableView = UITableView()
        self.items = items

        textField.placeholder = placeholder

        super.init(frame: .zero)
        setupUI()
        setupTableView()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        self.addSubview(textField)

        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(54)
        }

        self.snp.makeConstraints { make in
            self.heightConstraint = make.height.equalTo(76).constraint
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(hex: "#0099FA")?.cgColor
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tableView.rowHeight = 44
        self.tableView.register(PopupTableViewCell.self)
        tableView.isScrollEnabled = true

        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showOrHide))
        tapGesture.cancelsTouchesInView = false
        textField.addGestureRecognizer(tapGesture)
    }

    @objc private func showOrHide() {
        tableView.isHidden.toggle()

        let tableViewHeight = min(items.count, 5) * 44 + 44

        if tableView.isHidden {
            hideTableView()
        } else {
            showTableView(height: tableViewHeight)
        }
    }

    private func showTableView(height: Int) {
        self.textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        self.textField.setLeftImage(UIImage(named: "chevronRight"))

        tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }

        heightConstraint?.update(offset: 76 + height)

        self.layoutIfNeeded()
    }

    private func hideTableView() {
        self.textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]

        self.textField.setLeftImage(UIImage(named: "chevronRight"))

        tableView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }

        heightConstraint?.update(offset: 76)

        self.layoutIfNeeded()
    }

    public func setItems(_ items: [GameModel]) {
        self.items = items
        tableView.reloadData()
    }

    //MARK: Add Button action
    @objc private func addButtonTapped() {
        didTapAddButton?()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PopupField: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopupTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: items[indexPath.row].header)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row].header
        textField.text = selectedItem
        didSelectItem?(selectedItem)

        hideTableView()
    }
}
