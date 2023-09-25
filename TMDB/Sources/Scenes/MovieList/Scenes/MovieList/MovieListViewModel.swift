//
//  MovieListViewModel.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 23/09/2023.
//

import Foundation
import Combine

extension MovieListViewController {
    final class ViewModel {
        private let repository: MovieRepositoryProtocol
        @Published var movies: [Movie] = []
        
        private var cancellables = Set<AnyCancellable>()
        private var fetchMovies = PassthroughSubject<Void,Never>()
        var errorMessage = PassthroughSubject<String,Never>()
        private var loadMore = PassthroughSubject<Void,Never>()
        private var currentPage = 0
        private var isLoading: Bool = false
        private var canLoadMore: Bool = true
        init(repository: MovieRepositoryProtocol = MovieRepository()) {
            self.repository = repository
            bind()
        }
    }
}

// - MARK: Binding
private extension MovieListViewController.ViewModel {
    private func bind() {
        let fetch = fetchMovies
            .prepend()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map {
                return $0
            }
        
        let loadMore = loadMore.prepend().filter { [weak self] _ in
            self?.isLoading == false  && self?.canLoadMore == true
        }
                
        Publishers.Merge(fetch, loadMore)
            .map { [unowned self] _ in
                self.isLoading = true
                return self.repository.getMovies(page: self.currentPage + 1)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            }, receiveValue: {[weak self] movies in
                self?.isLoading = false
                self?.setData(movies)
            })
            .store(in: &cancellables)
//
//            .sink {[weak self] completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error)
//                }
//            } receiveValue: {[weak self] movies in
//                self?.isLoading = false
//                self?.setData(movies)
//            }
    }
    
}

// - MARK: Helper
private extension MovieListViewController.ViewModel {
    private func setData(_ movies: [Movie]) {
        if currentPage == 0 {
            self.movies = movies
        } else {
            self.movies.append(contentsOf: movies)
        }

        if movies.count > 0 {
            currentPage += 1
        }
        canLoadMore = movies.count > 0
    }
}

extension MovieListViewController.ViewModel {
    func getData() {
        fetchMovies.send()
    }
    
    func loadMoreData() {
        loadMore.send()
    }
}
