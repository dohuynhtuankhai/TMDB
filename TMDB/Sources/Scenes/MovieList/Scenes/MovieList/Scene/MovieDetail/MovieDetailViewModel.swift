//
//  MovieDetailViewModel.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 24/09/2023.
//

import Foundation
import Combine

extension MovieDetailViewController {
    final class ViewModel {
        private let repository: MovieRepositoryProtocol
        private let id: Int!
        @Published var movie: Movie?
        var errorMessage = PassthroughSubject<String,Never>()
        private var getDetail = PassthroughSubject<Void,Never>()
        private var cancellables = Set<AnyCancellable>()
        init(id: Int,
             repository: MovieRepositoryProtocol = MovieRepository()) {
            self.id = id
            self.repository = repository
            bind()
        }
    }
}

// - MARK: Binding
private extension MovieDetailViewController.ViewModel {
    private func bind() {
        getDetail.prepend()
            .map { [unowned self] _ in
                return self.repository.getMovieDetail(id: id)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            } receiveValue: {[weak self] movie in
                self?.movie = movie
            }
            .store(in: &cancellables)
    }
}

extension MovieDetailViewController.ViewModel {
    func getMovieDetail() {
        getDetail.send()
    }
}
