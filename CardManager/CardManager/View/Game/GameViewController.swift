//
//  GameViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class GameViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Games"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        setupConstraints()
        makeButtonActions()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        
    }
}


extension GameViewController: IViewModelableController {
    typealias ViewModel = IGameViewModel
}

//MARK: Button Actions
extension GameViewController {
    private func makeButtonActions() {
        
    }
}

//MARK: Preview
import SwiftUI

struct GameViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let gameViewController = GameViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<GameViewControllerProvider.ContainerView>) -> GameViewController {
            return gameViewController
        }

        func updateUIViewController(_ uiViewController: GameViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<GameViewControllerProvider.ContainerView>) {
        }
    }
}
