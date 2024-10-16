//
//  EditStrategyViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class EditStrategyViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let defaultImage = AddPhotoView()
    private let addImage = UIButton(type: .system)
    private var selectedImage: UIImage?

    private let nameField = TextField(placeholder: "Strategy name:")
    private var gameField: PopupField!
    private let descriptionField = TextView(placeholder: "Description:")

    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = self.viewModel?.model else { return }

        self.defaultImage.setup(with: model.image)
        self.selectedImage = model.image
        self.nameField.text = model.strategyName
        self.gameField.textField.text = model.gameName
        self.descriptionField.text = model.description
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Edit"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.saveButton.backgroundColor = UIColor(hex: "#39CC76")
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.setTitle("Edit", for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)

        self.gameField = PopupField(placeholder: "Game: gamename",
                                    items: [])

        self.view.addSubview(defaultImage)
        self.view.addSubview(addImage)
        self.view.addSubview(nameField)
        self.view.addSubview(gameField)
        self.view.addSubview(descriptionField)
        self.view.addSubview(saveButton)
        setupConstraints()
        makeButtonActions()
        setupTextFieldDelegates()
        setupViewTapHandling()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        if let games = self.viewModel?.games {
            self.gameField.setItems(games)
        }
    }

    func setupConstraints() {
        defaultImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(213)
        }

        addImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(100)
            view.centerX.equalToSuperview()
            view.width.equalTo(140)
            view.height.equalTo(140)
        }

        nameField.snp.makeConstraints { view in
            view.top.equalTo(defaultImage.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        gameField.snp.makeConstraints { view in
            view.top.equalTo(nameField.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
        }

        descriptionField.snp.makeConstraints { view in
            view.top.equalTo(gameField.tableView.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(124)
        }

        saveButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(58)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }
    }
}


extension EditStrategyViewController: IViewModelableController {
    typealias ViewModel = IEditStrategyViewModel
}

//MARK: Button Actions
extension EditStrategyViewController {
    private func makeButtonActions() {
        addImage.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    private func setupNavigationItems() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteGame))

        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#FF4444")
    }

    @objc func deleteGame() {
        guard let navigationController = self.navigationController else { return }
        guard let id = self.viewModel?.model.id else { return }
        self.viewModel?.deleteStrategy(by: id)

        StrategyRouter.popViewController(in: navigationController)
    }

    @objc func addImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }

    @objc func saveTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let image = self.selectedImage else { return }
        guard let name = self.nameField.text else { return }
        guard let gameName = self.gameField.textField.text else { return }
        guard let description = self.descriptionField.text else { return }
        guard let id = self.viewModel?.model.id else { return }

        self.viewModel?.editStrategy(.init(id: id,
                                           gameId: 1,
                                           image: image,
                                           strategyName: name,
                                           gameName: gameName,
                                           description: description,
                                           isFavorite: false))

        StrategyRouter.popViewController(in: navigationController)
    }
}

//MARK: UIGesture & cell's touches
extension EditStrategyViewController: UITextFieldDelegate {

    private func setupTextFieldDelegates() {
        self.nameField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameField:
            textFieldDidEndEditing(textField)
            self.nameField.resignFirstResponder()
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
        guard let name = nameField.text else { return true }
        guard let game = gameField.textField.text else { return true }
        guard let description = descriptionField.text else { return true }

        return name.isEmpty
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

//MARK: Image Picker
extension EditStrategyViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.defaultImage.setup(with: image)
        selectedImage = image
    }
}

//MARK: Preview
import SwiftUI

struct EditStrategyViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let editStrategyViewController = EditStrategyViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<EditStrategyViewControllerProvider.ContainerView>) -> EditStrategyViewController {
            return editStrategyViewController
        }

        func updateUIViewController(_ uiViewController: EditStrategyViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<EditStrategyViewControllerProvider.ContainerView>) {
        }
    }
}
