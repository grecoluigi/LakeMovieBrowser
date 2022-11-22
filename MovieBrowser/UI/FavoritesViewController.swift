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
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
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
        collectionView.delegate = self
        //collectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let sideInset: CGFloat = 24

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.collectionView.bounds.width), heightDimension: .estimated(250))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            let sectionSideInset = (environment.container.contentSize.width - self.collectionView.bounds.width) / 2
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
            section.orthogonalScrollingBehavior = .none
            return section
        }
        return layout
    }
}


extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionViewCell {
//            let vc = MovieDetailViewController(movieVM: cell.vm)
//            vc.modalPresentationStyle = .popover
//            self.present(vc, animated: true)
//        }
    }

}

//extension FavoritesViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let movie = favoritesVM.getMovie(at: indexPath.row)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
//            cell.vm = FavoriteCellViewModel(movie: movie)
//            cell.configure()
//            return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return favoritesVM.favoritesCount
//    }
//
//}
