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
    private let segmentedControl = UISegmentedControl(items: ["All",
                                                              "Favorites"])
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let createButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonActions()
        setupTableView()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Strategies"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor(hex: "#34343C")
        segmentedControl.selectedSegmentTintColor = UIColor(hex: "#0376FE")
        segmentedControl.layer.cornerRadius = 7
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        self.createButton.backgroundColor = UIColor(hex: "#39CC76")
        self.createButton.layer.cornerRadius = 12
        self.createButton.setTitle("Create", for: .normal)
        self.createButton.setTitleColor(.white, for: .normal)

        self.view.addSubview(segmentedControl)
        self.view.addSubview(tableView)
        self.view.addSubview(createButton)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.tableView.reloadData()

        viewModel?.activateSuccessSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.loadData()
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(166)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(32)
        }

        tableView.snp.makeConstraints { view in
            view.top.equalTo(segmentedControl.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        createButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(107)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(48)
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false

        self.tableView.register(EmptyTableViewCell.self)
        self.tableView.register(StrategyTableViewCell.self)
    }
}


extension StrategyViewController: IViewModelableController {
    typealias ViewModel = IStrategyViewModel
}

//MARK: Button Actions
extension StrategyViewController {
    private func makeButtonActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        createButton.addTarget(self, action: #selector(createStrategy), for: .touchUpInside)
    }

    @objc func createStrategy() {
        guard let navigationController = self.navigationController else { return }
        guard let subject = self.viewModel?.activateSuccessSubject else { return }

        StrategyRouter.showAddStrategyViewController(in: navigationController, navigationModel: .init(activateSuccessSubject: subject))
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        guard let strategies = self.viewModel?.strategies else { return }
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            self.viewModel?.filteredStrategies = strategies
            self.tableView.reloadData()
        case 1:
            self.viewModel?.filteredStrategies = strategies.filter { $0.isFavorite == true }
            self.tableView.reloadData()
        default:
            break
        }
    }

    private func editStrategy(for index: Int) {
        guard let navigationController = self.navigationController else { return }
        guard let subject = self.viewModel?.activateSuccessSubject else { return }

        let model = self.viewModel?.strategies[index]

        StrategyRouter.showEditStrategyViewController(in: navigationController,
                                              navigationModel: .init(activateSuccessSubject: subject, model: model!))
    }
}

//MARK: TableView Delegate & Data source
extension StrategyViewController:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.filteredStrategies.count ?? 0
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.filteredStrategies.isEmpty ?? true {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setup(with: "added strategies")
            return cell
        } else {
            let cell: StrategyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let model = viewModel?.filteredStrategies[indexPath.row] {
                cell.setup(strategyImage: model.image,
                           title: model.gameName,
                           strategyName: model.strategyName,
                           isFavorite: model.isFavorite)
            }

            cell.selectedSubject.sink { [weak self] _ in
                if let model = self?.viewModel?.filteredStrategies[indexPath.row] {
                    self?.viewModel?.editStrategy(.init(id: model.id,
                                                        gameId: model.gameId,
                                                        image: model.image,
                                                        strategyName: model.strategyName,
                                                        gameName: model.gameName,
                                                        description: model.description,
                                                        isFavorite: cell.isTapped))
                }
            }.store(in: &cell.cancellables)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel?.filteredStrategies.isEmpty ?? true {
            return 184
        } else {
            return 86
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editStrategy(for: indexPath.row)
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
