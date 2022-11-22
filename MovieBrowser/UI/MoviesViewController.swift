//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private let moviesVM : MoviesViewModel
    var collectionView : UICollectionView!
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieModel>
    
    init(vm: MoviesViewModel) {
        self.moviesVM = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        prepareUI()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        moviesVM.getMoviesByGenre()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        moviesVM.clearMovies()
        super.viewDidDisappear(animated)
    }
    
    private func setupBindings() {
        moviesVM.movies.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.applySnapshot()
            }
        }
        
        moviesVM.error.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let error = self?.moviesVM.error.value else { return }
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
                    withReuseIdentifier: MovieCollectionViewCell.identifier,
                    for: indexPath) as? MovieCollectionViewCell
                let apiManager = ApiManager()
                cell?.vm = MovieCellViewModel(movie: movie, movieDetailProvider: MovieDetailProvider(apiManager: apiManager))
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(moviesVM.movies.value)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func prepareUI() {
        prepareCollectionView()
        prepareActivityIndicator()
        addFavoritesBarButtonItem()
    }
    
    private func addFavoritesBarButtonItem() {
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "star.circle.fill"), style: .plain, target: self, action: #selector(showFavorites))
        self.navigationItem.rightBarButtonItem  = favoritesButton
    }
    
    @objc func showFavorites() {
        let favoritesVC = FavoritesViewController()
        favoritesVC.favoritesVM = FavoritesViewModel(genre: moviesVM.currentGenre)
        favoritesVC.modalPresentationStyle = .automatic
        present(favoritesVC, animated: true)
    }
    
    private func prepareActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }
    
    private func prepareCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier:MovieCollectionViewCell.identifier)
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let sideInset: CGFloat = 24
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.collectionView.bounds.width), heightDimension: .absolute(199))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            let sectionSideInset = (environment.container.contentSize.width - self.collectionView.bounds.width) / 2
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
            section.orthogonalScrollingBehavior = .none
            return section
        }
        return layout
    }
}
// MARK: - UIScrollViewDelegate

extension MoviesViewController: UIScrollViewDelegate {
    // Infinite loading
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView,
              (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height,
              !moviesVM.isLoadingMovies else { return }
        if moviesVM.currentPage < moviesVM.totalPages {
            moviesVM.currentPage += 1
            moviesVM.getMoviesByGenre()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
            let vc = MovieDetailViewController(movieVM: cell.vm)
            vc.modalPresentationStyle = .automatic
            self.present(vc, animated: true)
        }
    }
}
