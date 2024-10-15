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

class GameViewController: BaseViewController {

    var viewModel: ViewModel?
    private let winTab = GameTab(title: "Winnings")
    private let loseTab = GameTab(title: "Loses")
    private var winAndLose: UIStackView!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(self.viewModel?.games.count == 0) {
            let totalPlayed = self.viewModel?.games.reduce(0) { sum, game in
                sum + (Int(game.played) ?? 0)
            }

            let totalWins = self.viewModel?.games.reduce(0) { sum, game in
                sum + (Int(game.wins) ?? 0)
            }

            let totalLoses = totalPlayed! - totalWins!

            self.winTab.setup(count: "\(totalWins!)")
            self.loseTab.setup(count: "\(totalLoses)")
        }
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#090F1E")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Games"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.winAndLose = UIStackView(arrangedSubviews: [winTab, loseTab],
                                      axis: .horizontal,
                                      spacing: 16)

        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = ((numberOfColumns - 1) * spacing) + 16
        let availableWidth = self.view.frame.width - totalSpacing
        let itemWidth = availableWidth / numberOfColumns

        let myLayout = UICollectionViewFlowLayout()
        myLayout.itemSize = CGSize(width: itemWidth, height: 168)
        myLayout.scrollDirection = .vertical
        myLayout.minimumLineSpacing = spacing
        myLayout.minimumInteritemSpacing = spacing

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: myLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(EmptyCollectionViewCell.self)
        collectionView.register(GameCollectionViewCell.self)
        collectionView.registerReusableView(CollectionViewHeader.self,
                                            kind: UICollectionView.elementKindSectionHeader)
        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(winAndLose)
        self.view.addSubview(collectionView)
        setupConstraints()
        makeButtonActions()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.collectionView.reloadData()

        viewModel?.activateSuccessSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.loadData()
            self.collectionView.reloadData()
        }.store(in: &cancellables)
    }

    func setupConstraints() {
        winAndLose.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(166)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(72)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(winAndLose.snp.bottom).offset(18)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }
    }
}


extension GameViewController: IViewModelableController {
    typealias ViewModel = IGameViewModel
}

//MARK: Button Actions
extension GameViewController {
    private func makeButtonActions() {
        
    }

    private func addGame() {
        guard let subject = self.viewModel?.activateSuccessSubject else { return }
        guard let navigationController = self.navigationController else { return }
        GameRouter.showAddGameViewController(in: navigationController,
                                             navigationModel: .init(activateSuccessSubject: subject))
    }

    private func editGame(for index: Int) {
        guard let navigationController = self.navigationController else { return }
        guard let subject = self.viewModel?.activateSuccessSubject else { return }

        let model = self.viewModel?.games[index]

        GameRouter.showEditGameViewController(in: navigationController,
                                              navigationModel: .init(activateSuccessSubject: subject, model: model!))
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            let cell: GameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let game = viewModel?.games[indexPath.row] {
                cell.setup(with: .init(gameImage: game.image,
                                       title: game.header,
                                       played: game.played,
                                       wins: game.wins))
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: CollectionViewHeader = collectionView.dequeueCollectionReusableView(with: kind, indexPath: indexPath)

        headerView.setup(with: "Created games")

        headerView.addSubject.sink { [weak self] _ in
            self?.addGame()
        }.store(in: &headerView.cancellables)

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = self.viewModel?.games.count ?? 0

        if count == 0 {
            return CGSize(width: collectionView.frame.width, height: 150)
        } else {
            let numberOfColumns: CGFloat = 2
            let spacing: CGFloat = 10
            let totalSpacing = ((numberOfColumns - 1) * spacing) + 10
            let availableWidth = collectionView.frame.width - totalSpacing
            let itemWidth = availableWidth / numberOfColumns

            return CGSize(width: itemWidth, height: 168)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else { return }
        self.editGame(for: indexPath.row)
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
