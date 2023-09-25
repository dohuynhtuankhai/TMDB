//
//  MovieDBService.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation
import Combine
import RealmSwift

protocol MovieDBServiceProtocol {
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func getMovie(id: Int) -> AnyPublisher<Movie?, Error>
    func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], Error>
    func saveMovies(_ movie: [Movie])
    func deleteAllMovies()
}

final class MovieDBService: MovieDBServiceProtocol {
    func getMovie(id: Int) -> AnyPublisher<Movie?, Error> {
        return Future<Movie?, Error> { promise in
            do {
                let realm = try Realm()
                if let dbMovie = realm
                    .object(ofType: MovieDatabaseModel.self, forPrimaryKey: id) {
                    let movie: Movie = Movie(dbMovie)
                    promise(.success(movie))
                } else {
                    promise(.success(nil))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], Error> {
        return Future<[Movie], Error> { promise in
            do {
                let realm = try Realm()
                let dbMovies = realm
                    .objects(MovieDatabaseModel.self)
                    .where({ model in
                        model.title.contains(query) || model.overview.contains(query)
                    })
                    .sorted(by: \.index, ascending: true)
                
                let startIndex = (page - 1) * Config.paginationLimit
                let endIndex = min(startIndex + Config.paginationLimit - 1, dbMovies.count - 1)
                if startIndex > endIndex {
                    promise(.success([Movie]()))
                    return
                }

                let movies: [Movie] = dbMovies.map { Movie($0) }
                let result = Array(movies[startIndex...endIndex])
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return Future<[Movie], Error> { promise in
            do {
                let realm = try Realm()
                let dbMovies = realm
                    .objects(MovieDatabaseModel.self)
                    .sorted(by: \.index, ascending: true)
                
                let startIndex = (page - 1) * Config.paginationLimit
                let endIndex = min(startIndex + Config.paginationLimit - 1, dbMovies.count - 1)
                if startIndex > endIndex {
                    promise(.success([Movie]()))
                    return
                }

                let movies: [Movie] = dbMovies.map { Movie($0) }
                let result = Array(movies[startIndex...endIndex])
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveMovies(_ movies: [Movie]) {
        do {
            var currentLargestIndex = 0
            let realm = try Realm()
            if let largestIndex = realm
                .objects(MovieDatabaseModel.self).max(of: \.index) {
                currentLargestIndex = largestIndex
            }
            
            let dbMovies = movies.enumerated().map { (index, movie) in
                return MovieDatabaseModel(movie, index: currentLargestIndex + index + 1)
            }
            
            for movie in dbMovies {
                if realm
                    .object(ofType: MovieDatabaseModel.self, forPrimaryKey: movie.id) != nil {
                    print("Movie already exist \(movie.id)")
                } else {
                    try realm.write({
                        realm.add(movie)
                    })
                }
            }

        } catch {
            print("Failed to fetch todos from service: \(error)")
        }
    }
    
    func deleteAllMovies() {
        do {
            let realm = try Realm()
            try realm.write {
                let movies = realm.objects(MovieDatabaseModel.self)
                realm.delete(movies)
            }
        } catch {
            print("Failed to delete movies: \(error)")
        }
    }
}
