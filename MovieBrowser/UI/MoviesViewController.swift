//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    private enum Constants {
        static let cellId = "GenresCell"
        static let title = "Genres"
    }
    
    private let moviesVM : MoviesViewModel
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        moviesVM.getMoviesByGenre()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moviesVM.clearMovies()
        super.viewWillDisappear(animated)
    }
    
    private func setupBindings() {
        moviesVM.movies.bind { [weak self] (_) in
            let movies = self!.moviesVM.movies.value
            print("Got \(movies.count) movies")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
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
        prepareTableView()
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
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesVM.movies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = moviesVM.movies.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = movie.title
        cell.contentConfiguration = configuration
        return cell 
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UIScrollViewDelegate

extension MoviesViewController: UIScrollViewDelegate {
    
    // Infinite loading
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == tableView,
              (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height,
              !moviesVM.isLoadingMovies else { return }
        if moviesVM.currentPage < moviesVM.totalPages {
            moviesVM.currentPage += 1
            moviesVM.getMoviesByGenre()
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
}
