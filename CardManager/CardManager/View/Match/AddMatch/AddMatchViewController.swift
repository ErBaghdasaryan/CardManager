//
//  AddMatchViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class AddMatchViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private var nameField: PopupField!
    private let playerField = TextField(placeholder: "Players: 5")
    private let dateField = TextField(placeholder: "Date: 13/11/2023 5:24PM")
    private let statusField = TextField(placeholder: "Status: WIN/LOSE")
    private let profitField = TextField(placeholder: "Profit: $320")
    private let betField = TextField(placeholder: "Bet: $200")

    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Add Match"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.saveButton.backgroundColor = UIColor(hex: "#39CC76")
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.setTitle("Create", for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)

        self.nameField = PopupField(placeholder: "Name: Texas Hold'em",
                                    items: [])

        self.view.addSubview(nameField)
        self.view.addSubview(playerField)
        self.view.addSubview(dateField)
        self.view.addSubview(statusField)
        self.view.addSubview(profitField)
        self.view.addSubview(betField)
        self.view.addSubview(saveButton)
        setupConstraints()
        makeButtonActions()
        setupTextFieldDelegates()
        setupViewTapHandling()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        if let games = self.viewModel?.games {
            self.nameField.setItems(games)
        }
    }

    func setupConstraints() {

        nameField.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
        }

        playerField.snp.makeConstraints { view in
            view.top.equalTo(nameField.tableView.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        dateField.snp.makeConstraints { view in
            view.top.equalTo(playerField.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        statusField.snp.makeConstraints { view in
            view.top.equalTo(dateField.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        profitField.snp.makeConstraints { view in
            view.top.equalTo(statusField.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        betField.snp.makeConstraints { view in
            view.top.equalTo(profitField.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        saveButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(58)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }
    }
}


extension AddMatchViewController: IViewModelableController {
    typealias ViewModel = IAddMatchViewModel
}

//MARK: Button Actions
extension AddMatchViewController {
    private func makeButtonActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc func saveTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let name = nameField.textField.text else { return }
        guard let players = playerField.text else { return }
        guard let date = dateField.text else { return }
        guard let status = statusField.text else { return }
        guard let profit = profitField.text else { return }
        guard let bet = betField.text else { return }

        self.viewModel?.addMatch(model: .init(gameId: 1,
                                              name: name,
                                              players: players,
                                              date: date,
                                              status: status,
                                              profit: profit,
                                              bet: bet,
                                              isFavorite: false))

        MatchRouter.popViewController(in: navigationController)
    }
}

//MARK: UIGesture & cell's touches
extension AddMatchViewController: UITextFieldDelegate {

    private func setupTextFieldDelegates() {
        self.nameField.textField.delegate = self
        self.playerField.delegate = self
        self.dateField.delegate = self
        self.statusField.delegate = self
        self.profitField.delegate = self
        self.betField.delegate = self

        self.playerField.keyboardType = .numberPad
        self.profitField.keyboardType = .numberPad
        self.betField.keyboardType = .numberPad
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameField.textField:
            textFieldDidEndEditing(textField)
            self.playerField.becomeFirstResponder()
        case self.playerField:
            textFieldDidEndEditing(textField)
            self.dateField.becomeFirstResponder()
        case self.dateField:
            textFieldDidEndEditing(textField)
            self.statusField.becomeFirstResponder()
        case self.statusField:
            textFieldDidEndEditing(textField)
            self.profitField.becomeFirstResponder()
        case self.profitField:
            textFieldDidEndEditing(textField)
            self.betField.becomeFirstResponder()
        case self.betField:
            textFieldDidEndEditing(textField)
            self.betField.resignFirstResponder()
        default:
            break
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonBackgroundColor()
    }

    private func updateButtonBackgroundColor() {
        let allFieldsFilled = !checkAllFields()
        let buttonColor = allFieldsFilled ? UIColor(hex: "#39CC76") : UIColor(hex: "#39CC76")!.withAlphaComponent(0.5)
        self.saveButton.backgroundColor = buttonColor
        self.saveButton.isUserInteractionEnabled = allFieldsFilled ? true : false
    }

    private func checkAllFields() -> Bool {
        guard let name = nameField.textField.text else { return true }
        guard let players = playerField.text else { return true }
        guard let date = dateField.text else { return true }
        guard let status = statusField.text else { return true }
        guard let profit = profitField.text else { return true }
        guard let bet = betField.text else { return true }

        return name.isEmpty || players.isEmpty || date.isEmpty || status.isEmpty || profit.isEmpty || bet.isEmpty
    }

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

    private func setupViewTapHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
}


//MARK: Preview
import SwiftUI

struct AddMatchViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let addMatchViewController = AddMatchViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddMatchViewControllerProvider.ContainerView>) -> AddMatchViewController {
            return addMatchViewController
        }

        func updateUIViewController(_ uiViewController: AddMatchViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AddMatchViewControllerProvider.ContainerView>) {
        }
    }
}
