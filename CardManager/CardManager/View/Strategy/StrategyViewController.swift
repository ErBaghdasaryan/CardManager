//
//  StrategyViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class StrategyViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Strategies"
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


extension StrategyViewController: IViewModelableController {
    typealias ViewModel = IStrategyViewModel
}

//MARK: Button Actions
extension StrategyViewController {
    private func makeButtonActions() {
        
    }
}

//MARK: Preview
import SwiftUI

struct StrategyViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let strategyViewController = StrategyViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<StrategyViewControllerProvider.ContainerView>) -> StrategyViewController {
            return strategyViewController
        }

        func updateUIViewController(_ uiViewController: StrategyViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<StrategyViewControllerProvider.ContainerView>) {
        }
    }
}
