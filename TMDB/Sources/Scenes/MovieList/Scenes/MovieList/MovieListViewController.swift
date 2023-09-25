//
//  File.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import UIKit
import Combine

class MovieListViewController: BaseViewController {
    override var screenName: String? { return "Movies"}
    
    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable> = []
    
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
    
    private lazy var searchButton: UIBarButtonItem = {
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        return searchButton
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
        viewModel.getData()
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
        navigationItem.rightBarButtonItem = searchButton
        view.addSubview(tableView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func searchButtonTapped() {
        let destinationVC = SearchMovieViewController(.init())
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func showToast() {
        
    }
}
