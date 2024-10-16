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
    private let profit = WinStat(winOrLose: .profit)
    private let loses = WinStat(winOrLose: .lose)
    private var winStat: UIStackView!
    private let matches = MatchStat(matchOrRate: .match)
    private let rate = MatchStat(matchOrRate: .rate)
    private var secondStats: UIStackView!
    private let mostPlayed = MostPlayed(isPlayed: false)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profit = self.viewModel?.profit else { return }
        guard let bet = self.viewModel?.bet else { return }
        guard let matches = self.viewModel?.matchesCount else { return }

        self.profit.setup(count: profit)
        self.loses.setup(count: bet)
        self.matches.setup(matchesOrRate: matches)
        self.rate.setup(matchesOrRate: "12.0")
        self.mostPlayed.setup(isPlayed: true)
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Statistics"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.winStat = UIStackView(arrangedSubviews: [profit, loses],
                                   axis: .horizontal,
                                   spacing: 12)

        self.secondStats = UIStackView(arrangedSubviews: [matches, rate],
                                       axis: .horizontal,
                                       spacing: 12)

        self.view.addSubview(winStat)
        self.view.addSubview(secondStats)
        self.view.addSubview(mostPlayed)
        setupConstraints()
        makeButtonActions()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        winStat.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(151)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(87)
        }

        secondStats.snp.makeConstraints { view in
            view.top.equalTo(winStat.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(56)
        }

        mostPlayed.snp.makeConstraints { view in
            view.top.equalTo(secondStats.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(362)
        }
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
