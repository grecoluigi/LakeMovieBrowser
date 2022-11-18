//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    private enum Constants {
        static let cellId = "movieCell"
        static let collectionViewCellId = "movieCollectionViewCell"
    }
    
    enum Section {
      case main
    }
    
    private let moviesVM : MoviesViewModel
    var collectionView : UICollectionView!
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
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
        //showLoadMoreView()
    }
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, movie) ->
          UICollectionViewCell? in
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "movieCollectionViewCell",
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
                UIAlertController.alert("Error".localized, error, completion: { (okaction) in })
            }
        }
    }
    
    private func prepareUI() {
        prepareCollectionView()
        prepareActivityIndicator()
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
        collectionView.register(UINib(nibName:"MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"movieCollectionViewCell")
        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
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
            //showLoadMoreView()
            //showActivityIndicatory()
            //let spinner = UIActivityIndicatorView(style: .medium)
            //spinner.startAnimating()
            //spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            //view.addSubview(spinner)
            //view.bringSubviewToFront(spinner)
            //self.collectionView.supplementaryView(forElementKind: <#T##String#>, at: <#T##IndexPath#>)
            //self.tableView.tableFooterView = spinner
            //self.tableView.tableFooterView?.isHidden = false
             
        }
    }
}
 


// MARK: - Loading More View
extension MoviesViewController {
    func showActivityIndicatory() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .blue
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(activityIndicator)
        
        self.view.addSubview(container)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 30),
            container.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
    }
    
    func showLoadMoreView() {
        let popOver = UIView()
            popOver.isHidden = true
            popOver.frame = CGRectMake(self.view.frame.width / 2, 20, 0, 0)
        popOver.translatesAutoresizingMaskIntoConstraints = false
            popOver.backgroundColor = .blue
            popOver.layer.cornerRadius = 9
            self.view.addSubview(popOver)
        NSLayoutConstraint.activate([
            popOver.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popOver.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: popOver.bounds.width, height: popOver.bounds.height)
        spinner.center = popOver.center
            popOver.addSubview(spinner)
            popOver.bringSubviewToFront(spinner)


        UIView.animate(withDuration: 1.0, animations: {
                popOver.isHidden = false
            })
    }
}

extension MoviesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item")
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell {
            let vc = MovieDetailViewController(movieVM: cell.vm)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        } 
    }
}
