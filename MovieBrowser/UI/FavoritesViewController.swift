//
//  FavoritesViewController.swift
//  MovieBrowser
//
//  Created by Luigi on 20/11/2022.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController : UIViewController {
    
    enum Section {
      case main
    }
    
    var collectionView : UICollectionView!
    var favoritesVM : FavoritesViewModel!
    private lazy var dataSource = makeDataSource()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        prepareUI()
        favoritesVM.addObserver()
        favoritesVM.loadFavorites()
        applySnapshot(animatingDifferences: false)
    }
    
    private func setupBindings() {
        favoritesVM.favorites.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.applySnapshot()
            }
        }
        
        favoritesVM.error.bind { [weak self] (_) in
            DispatchQueue.main.async {
                guard let error = self?.favoritesVM.error.value else { return }
                let alert = UIAlertController(title: "error".localized, message: error, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                alert.addAction(cancelAction)
                self?.present(alert, animated: true)
            }
        }
    }
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, movie) ->
          UICollectionViewCell? in
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteCollectionViewCell.identifier,
            for: indexPath) as! FavoriteCollectionViewCell
            cell.vm = FavoriteCellViewModel(movie: movie)
            cell.configure()
          return cell
      })
      return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
        snapshot.appendItems(favoritesVM.favorites.value)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func prepareUI() {
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.textAlignment = .center
        if let currentGenre = favoritesVM.currentGenre?.name {
            label.text = "favoritesFor".localized + currentGenre
        } else {
            label.text = "favorites".localized
        }
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        collectionView.register(FavoriteCollectionViewCell.nib(), forCellWithReuseIdentifier:FavoriteCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let sideInset: CGFloat = 4

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.collectionView.bounds.width), heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            let sectionSideInset = (environment.container.contentSize.width - self.collectionView.bounds.width) / 2
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
            section.orthogonalScrollingBehavior = .none
            return section
        }
        return layout
    }
}
