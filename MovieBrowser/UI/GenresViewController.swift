//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class GenresViewController: UIViewController {
    private enum Constants {
        static let cellId = "GenresCell"
        static let title = "genres".localized
    }

    private let genresVM : GenresViewModel
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    init(vm: GenresViewModel) {
        self.genresVM = vm
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        genresVM.getGenres()
    }
    
    private func setupBindings() {
        
        genresVM.error.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let error = self?.genresVM.error.value else { return }
                let alert = UIAlertController(title: "error".localized, message: error, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
                alert.addAction(cancelAction)
                self?.present(alert, animated: true)
            }
        }
        
        genresVM.genres.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareActivityIndicator()
        addFavoritesBarButtonItem()
    }

    private func prepareRootView() {
        title = Constants.title
    }

    private func prepareTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
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
    
    private func addFavoritesBarButtonItem() {
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "star.circle.fill"), style: .plain, target: self, action: #selector(showFavorites))
        self.navigationItem.rightBarButtonItem  = favoritesButton
    }
    
    @objc func showFavorites() {
        let favoritesVC = FavoritesViewController()
        favoritesVC.favoritesVM = FavoritesViewModel()
        favoritesVC.modalPresentationStyle = .automatic
        present(favoritesVC, animated: true)
    }
    
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let apiManager = ApiManager()
        let moviesProvider = MoviesProvider(apiManager: apiManager)
        let genre = genresVM.genres.value[indexPath.row]
        let moviesViewModel = MoviesViewModel(moviesProvider: moviesProvider, genre: genre)
        let moviesVC = MoviesViewController(vm: moviesViewModel)
        moviesVC.title = genre.name
        navigationController?.pushViewController(moviesVC, animated: true)
    }
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        genresVM.genres.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = genresVM.genres.value[indexPath.row].name
        cell.contentConfiguration = configuration
        return cell
    }
}
