//
//  SearchMovieViewController.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 24/09/2023.
//

import UIKit
import Combine

class SearchMovieViewController: BaseViewController  {
    override var screenName: String? { return "Search Movie"}
    
    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Enter movie name"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self)
        return tableView
    }()
    
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    private func bindUI() {
        viewModel.$movies
            .dropFirst()
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] errorMessage in
                self?.showToast(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
