//
//  AddGameViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class AddGameViewController: BaseViewController, UICollectionViewDelegate {

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

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Add Game"
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


extension AddGameViewController: IViewModelableController {
    typealias ViewModel = IAddGameViewModel
}

//MARK: Button Actions
extension AddGameViewController {
    private func makeButtonActions() {
        addImage.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
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

        self.viewModel?.addGame(.init(header: name,
                                      image: image,
                                      description: description,
                                      played: timePlayed,
                                      wins: winRate))

        GameRouter.popViewController(in: navigationController)
    }
}

//MARK: UIGesture & cell's touches
extension AddGameViewController: UITextFieldDelegate {

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
extension AddGameViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.defaultImage.setup(with: image)
        selectedImage = image
    }
}

//MARK: Preview
import SwiftUI

struct AddGameViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let addGameViewController = AddGameViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddGameViewControllerProvider.ContainerView>) -> AddGameViewController {
            return addGameViewController
        }

        func updateUIViewController(_ uiViewController: AddGameViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AddGameViewControllerProvider.ContainerView>) {
        }
    }
}
