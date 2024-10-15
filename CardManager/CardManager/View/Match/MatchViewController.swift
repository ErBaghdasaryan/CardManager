//
//  MatchViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class MatchViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Matches"
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


extension MatchViewController: IViewModelableController {
    typealias ViewModel = IMatchViewModel
}

//MARK: Button Actions
extension MatchViewController {
    private func makeButtonActions() {
        
    }
}

//MARK: Preview
import SwiftUI

struct MatchViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let matchViewController = MatchViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MatchViewControllerProvider.ContainerView>) -> MatchViewController {
            return matchViewController
        }

        func updateUIViewController(_ uiViewController: MatchViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MatchViewControllerProvider.ContainerView>) {
        }
    }
}
