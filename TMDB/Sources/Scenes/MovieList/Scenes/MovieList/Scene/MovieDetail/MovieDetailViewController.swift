//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 24/09/2023.
//

import Foundation
import Combine
import UIKit

class MovieDetailViewController: BaseViewController {
    
    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    // - MARK: View variables
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: .largeFont, weight: .black)
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: .mediumFont, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: .regularFont, weight: .medium)
        label.textColor = .blue
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: .regularFont, weight: .regular)
        label.textColor = .black
        return label
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
        bindUI()
        setupUI()
        viewModel.getMovieDetail()
    }
    
    private func bindUI() {
        viewModel.$movie
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setData()
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
    
    private func setData() {
        guard let movie = viewModel.movie else {
            return
        }
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        ratingLabel.text = String(format: "%.2f", movie.voteAverage)
        overviewLabel.text = movie.overview
        if let imagePath = URL(string: "\(Config.baseImageUrl)\(movie.posterPath)") {
            movieImageView.kf.indicatorType = .activity
            movieImageView.kf.setImage(with: imagePath)
        }
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(mainStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dateLabel)
        infoStackView.addArrangedSubview(ratingLabel)
        outerStackView.addArrangedSubview(movieImageView)
        outerStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(outerStackView)
        mainStackView.addArrangedSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: .tinyPadding),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -.tinyPadding),
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: .tinyPadding),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -.tinyPadding),
        ])
    }
}
