//
//  MoviesRepository.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation
import Combine

protocol MovieRepositoryProtocol {
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func searchMovie(query: String, page: Int) -> AnyPublisher<[Movie], Error>
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error>
}

final class MovieRepository: MovieRepositoryProtocol {
    let movieAPIClient: MovieAPIProvider
    let movieDBService: MovieDBServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(movieAPIClient: MovieAPIProvider = MovieAPIClient(),
         movieDBService: MovieDBServiceProtocol = MovieDBService()) {
        self.movieAPIClient = movieAPIClient
        self.movieDBService = movieDBService
    }
    
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        movieAPIClient
            .request(.getMovies(info: .init(page: page)))
            .map { [weak self] movies in
                if page == 1 {
                    self?.movieDBService.deleteAllMovies()
                }
                self?.movieDBService.saveMovies(movies)
                return movies
            }
            .catch { [unowned self] error -> AnyPublisher<[Movie], Error> in
                return self.movieDBService.getMovies(page: page)
            }.eraseToAnyPublisher()
    }
    
    func searchMovie(query: String, page: Int) -> AnyPublisher<[Movie], Error> {
        movieAPIClient
            .request(.searchMovies(info: .init(query: query, page: page)))
            .map { movies in
                return movies
            }
            .catch { [unowned self] error -> AnyPublisher<[Movie], Error> in
                return self.movieDBService.searchMovies(query: query, page: page)
            }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(id: Int) -> AnyPublisher<Movie?, Error> {
        movieAPIClient
            .requestDetail(.getMovieDetail(info: .init(movieId: id)))
            .map { movie in
                return movie
            }
            .catch { [unowned self] error -> AnyPublisher<Movie?, Error> in
                return self.movieDBService.getMovie(id: id)
            }.eraseToAnyPublisher()
    }
}
