//
//  EditGameViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class EditGameViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let defaultImage = AddPhotoView()
    private let addImage = UIButton(type: .system)
    private var selectedImage: UIImage?

    private let nameField = TextField(placeholder: "Name:")
    private let descriptionField = TextView(placeholder: "Description:")
    private let timePlayedField = TextField(placeholder: "Times played:")
    private let winRate = TextField(placeholder: "Win-rate, %:")

    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = self.viewModel?.model else { return }

        self.defaultImage.setup(with: model.image)
        self.selectedImage = model.image
        self.nameField.text = model.header
        self.descriptionField.text = model.description
        self.timePlayedField.text = model.played
        self.winRate.text = model.wins
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
        self.saveButton.setTitle("Save", for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)

        self.view.addSubview(defaultImage)
        self.view.addSubview(addImage)
        self.view.addSubview(nameField)
        self.view.addSubview(descriptionField)
        self.view.addSubview(timePlayedField)
        self.view.addSubview(winRate)
        self.view.addSubview(saveButton)
        setupConstraints()
        makeButtonActions()
        setupTextFieldDelegates()
        setupViewTapHandling()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

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

        descriptionField.snp.makeConstraints { view in
            view.top.equalTo(nameField.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(124)
        }

        timePlayedField.snp.makeConstraints { view in
            view.top.equalTo(descriptionField.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        winRate.snp.makeConstraints { view in
            view.top.equalTo(timePlayedField.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }

        saveButton.snp.makeConstraints { view in
            view.top.equalTo(winRate.snp.bottom).offset(51)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }
    }
}


extension EditGameViewController: IViewModelableController {
    typealias ViewModel = IEditGameViewModel
}

//MARK: Button Actions
extension EditGameViewController {
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
        self.viewModel?.deleteGame(by: id)

        GameRouter.popViewController(in: navigationController)
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
        guard let description = self.descriptionField.text else { return }
        guard let timePlayed = self.timePlayedField.text else { return }
        guard let winRate = self.winRate.text else { return }
        guard let id = self.viewModel?.model.id else { return }

        self.viewModel?.editGame(.init(id: id,
                                       header: name,
                                       image: image,
                                       description: description,
                                       played: timePlayed,
                                       wins: winRate))

        GameRouter.popViewController(in: navigationController)
    }
}

//MARK: UIGesture & cell's touches
extension EditGameViewController: UITextFieldDelegate {

    private func setupTextFieldDelegates() {
        self.nameField.delegate = self
        self.timePlayedField.delegate = self
        self.winRate.delegate = self

        timePlayedField.keyboardType = .numberPad
        winRate.keyboardType = .numberPad
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameField:
            textFieldDidEndEditing(textField)
            self.timePlayedField.becomeFirstResponder()
        case self.timePlayedField:
            textFieldDidEndEditing(textField)
            self.winRate.becomeFirstResponder()
        case self.winRate:
            textFieldDidEndEditing(textField)
            self.winRate.resignFirstResponder()
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
        guard let description = descriptionField.text else { return true }
        guard let timesPlayes = timePlayedField.text else { return true }
        guard let winRate = winRate.text else { return true }

        return name.isEmpty || description.isEmpty || timesPlayes.isEmpty || winRate.isEmpty
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
extension EditGameViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.defaultImage.setup(with: image)
        selectedImage = image
    }
}

//MARK: Preview
import SwiftUI

struct EditGameViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let editGameViewController = EditGameViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<EditGameViewControllerProvider.ContainerView>) -> EditGameViewController {
            return editGameViewController
        }

        func updateUIViewController(_ uiViewController: EditGameViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<EditGameViewControllerProvider.ContainerView>) {
        }
    }
}
