//
//  StatisticViewController.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerViewModel
import SnapKit
import StoreKit

class StatisticViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Statistics"
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


extension StatisticViewController: IViewModelableController {
    typealias ViewModel = IStatisticViewModel
}

//MARK: Button Actions
extension StatisticViewController {
    private func makeButtonActions() {
        
    }
}

//MARK: Preview
import SwiftUI

struct StatisticViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let statisticViewController = StatisticViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<StatisticViewControllerProvider.ContainerView>) -> StatisticViewController {
            return statisticViewController
        }

        func updateUIViewController(_ uiViewController: StatisticViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<StatisticViewControllerProvider.ContainerView>) {
        }
    }
}
