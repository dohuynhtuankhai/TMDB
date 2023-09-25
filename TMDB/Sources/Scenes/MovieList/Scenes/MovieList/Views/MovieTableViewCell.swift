//
//  MovieTableViewCell.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    private var movie: Movie!
    
    // - MARK: View variables
    let mainView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = .white
        view.layer.cornerRadius = .regularRadius
        view.clipsToBounds = true
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(_ movie: Movie) {
        self.movie = movie
        self.setupView()
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        ratingLabel.text = String(format: "%.2f", movie.voteAverage)
        if let imagePath = URL(string: "\(Config.baseImageUrl)\(movie.posterPath)") {
            movieImageView.kf.indicatorType = .activity
            movieImageView.kf.setImage(with: imagePath)
        }
    }
    
    // - MARK: Setup View
    private func setupView() {
        contentView.addSubview(mainView)
        mainView.addSubview(outerStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dateLabel)
        infoStackView.addArrangedSubview(ratingLabel)
        outerStackView.addArrangedSubview(movieImageView)
        outerStackView.addArrangedSubview(infoStackView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .tinyPadding),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.tinyPadding),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .tinyPadding),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.tinyPadding),
            
            outerStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: .tinyPadding),
            outerStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -.tinyPadding),
            outerStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: .tinyPadding),
            outerStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -.tinyPadding),
        ])
    }
}
