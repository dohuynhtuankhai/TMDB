//
//  SearchMovieViewModel.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 24/09/2023.
//

import Foundation
import Combine

extension SearchMovieViewController {
    final class ViewModel {
        private let repository: MovieRepositoryProtocol
        @Published var movies: [Movie] = []
        @Published var searchText: String = ""
        private var loadMore = PassthroughSubject<Void,Never>()
        var errorMessage = PassthroughSubject<String,Never>()
        private var cancellables = Set<AnyCancellable>()
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
private extension SearchMovieViewController.ViewModel {
    private func bind() {
        let query = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map {
                return $0
            }
        
        let loadMore = loadMore.prepend().filter { [weak self] _ in
            self?.isLoading == false  && self?.canLoadMore == true
        }
        
        Publishers.CombineLatest(query, loadMore)
            .map { [unowned self] query, _ in
                if query.isEmpty { self.currentPage = 0 }
                return self.repository.searchMovie(query: query, page: self.currentPage + 1)
            }
            .switchToLatest()
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage.send(error.localizedDescription)
                }
            } receiveValue: {[weak self] movies in
                self?.isLoading = false
                self?.setData(movies)
            }
            .store(in: &cancellables)
        
    }
}

// - MARK: Helper
private extension SearchMovieViewController.ViewModel {
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

extension SearchMovieViewController.ViewModel {
    func getData(query: String) {
        searchText = query
        loadMore.send()
    }
    
    func loadMoreData() {
        loadMore.send()
    }
}
