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

class MatchViewController: BaseViewController {

    var viewModel: ViewModel?

    private let segmentedControl = UISegmentedControl(items: ["All",
                                                              "Favorites"])
    var collectionView: UICollectionView!
    private var selectedIndexPath: IndexPath?

    private let playedLabel = UILabel(text: "Played matches",
                                      textColor: .white,
                                      font: UIFont(name: "SFProText-Semibold", size: 17))

    private let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonActions()
        setupTableView()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Matches"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor(hex: "#34343C")
        segmentedControl.selectedSegmentTintColor = UIColor(hex: "#0376FE")
        segmentedControl.layer.cornerRadius = 7
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        let myLayout = UICollectionViewFlowLayout()
        myLayout.itemSize = CGSize(width: 136, height: 130)
        myLayout.scrollDirection = .horizontal
        myLayout.minimumLineSpacing = 12
        myLayout.minimumInteritemSpacing = 12

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: myLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(EmptyCollectionViewCell.self)
        collectionView.register(MatchGameCollectionViewCell.self)

        collectionView.delegate = self
        collectionView.dataSource = self

        playedLabel.textAlignment = .left

        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true

        self.view.addSubview(segmentedControl)
        self.view.addSubview(collectionView)
        self.view.addSubview(playedLabel)
        self.view.addSubview(tableView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.collectionView.reloadData()
        self.viewModel?.loadMatches()
        self.tableView.reloadData()

        viewModel?.activateSuccessSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.loadMatches()
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }

    func setupConstraints() {
        segmentedControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(166)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(32)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(segmentedControl.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview()
            view.height.equalTo(136)
        }

        playedLabel.snp.makeConstraints { view in
            view.top.equalTo(collectionView.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview()
            view.height.equalTo(18)
        }

        tableView.snp.makeConstraints { view in
            view.top.equalTo(playedLabel.snp.bottom).offset(24)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false

        self.tableView.register(EmptyTableViewCell.self)
        self.tableView.register(PlayedMatchTableViewCell.self)
    }
}


extension MatchViewController: IViewModelableController {
    typealias ViewModel = IMatchViewModel
}

//MARK: Button Actions
extension MatchViewController {
    private func makeButtonActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        guard let matches = self.viewModel?.matches else { return }
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            self.viewModel?.filteredMatches = matches
            self.tableView.reloadData()
        case 1:
            self.viewModel?.filteredMatches = matches.filter { $0.isFavorite == true }
            self.tableView.reloadData()
        default:
            break
        }
    }

    private func setupNavigationItems() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addMatch))

        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: "#0376FE")
    }

    @objc func addMatch() {
        guard let navigationController = self.navigationController else { return }
        guard let subject = self.viewModel?.activateSuccessSubject else { return }

        MatchRouter.showAddMatchViewController(in: navigationController,
                                               navigationModel: .init(activateSuccessSubject: subject))
    }

    private func editMatch(for index: Int) {
        guard let navigationController = self.navigationController else { return }
        guard let subject = self.viewModel?.activateSuccessSubject else { return }

        let model = self.viewModel?.matches[index]

        MatchRouter.showEditMatchViewController(in: navigationController,
                                              navigationModel: .init(activateSuccessSubject: subject, model: model!))
    }
}

extension MatchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel?.games.count ?? 0
        return count == 0 ? 1 : count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = self.viewModel?.games.count ?? 0
        if count == 0 {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            let cell: MatchGameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let game = viewModel?.games[indexPath.row] {
                cell.setup(with: .init(gameImage: game.image,
                                       title: game.header,
                                       played: game.played,
                                       wins: game.wins))
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = self.viewModel?.games.count ?? 0

        if count == 0 {
            return CGSize(width: collectionView.frame.width, height: 150)
        } else {
            return CGSize(width: 136, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath, previousIndexPath == indexPath {
            guard let cell = collectionView.cellForItem(at: indexPath) as? MatchGameCollectionViewCell else { return }
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            selectedIndexPath = nil
        } else {
            if let previousIndexPath = selectedIndexPath {
                guard let previousCell = collectionView.cellForItem(at: previousIndexPath) as? MatchGameCollectionViewCell else { return }
                previousCell.layer.borderColor = UIColor.clear.cgColor
                previousCell.layer.borderWidth = 0
            }

            guard let cell = collectionView.cellForItem(at: indexPath) as? MatchGameCollectionViewCell else { return }
            cell.layer.borderColor = UIColor(hex: "#0057FF")?.cgColor
            cell.layer.borderWidth = 2

            selectedIndexPath = indexPath
        }
    }
}

//MARK: TableView Delegate & Data source
extension MatchViewController:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.filteredMatches.count ?? 0
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.filteredMatches.isEmpty ?? true {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setup(with: "played matches")
            return cell
        } else {
            let cell: PlayedMatchTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let model = viewModel?.filteredMatches[indexPath.row] {
                cell.setup(date: model.date,
                           winOrLose: model.status,
                           amount: model.profit,
                           bet: model.bet,
                           players: model.players,
                           isFavorite: model.isFavorite)
            }

            cell.selectedSubject.sink { [weak self] _ in
                if let model = self?.viewModel?.matches[indexPath.row] {
                    self?.viewModel?.editMatch(.init(id: model.id,
                                                     gameId: model.gameId,
                                                     name: model.name,
                                                     players: model.players,
                                                     date: model.date,
                                                     status: model.status,
                                                     profit: model.profit,
                                                     bet: model.bet,
                                                     isFavorite: cell.isTapped))
                }
            }.store(in: &cell.cancellables)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel?.filteredMatches.isEmpty ?? true {
            return 184
        } else {
            return 116
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editMatch(for: indexPath.row)
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
