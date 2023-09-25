//
//  MovieAPI.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation
import Alamofire
import Combine

enum MoviesAPI: APIRouter {
    struct GetMovies: Encodable {
        let page: Int
    }
    
    struct SearchMovies: Encodable {
        let query: String
        let page: Int
    }
    
    case getMovies(info: GetMovies)
    case searchMovies(info: SearchMovies)
    
    var method: HTTPMethod {
        switch self {
        case .getMovies, .searchMovies:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return "/trending/movie/week"
        case .searchMovies:
            return "/search/movie"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getMovies(let info):
            return info.asDictionary(using: Self.encoder)
        case .searchMovies(let info):
            return info.asDictionary(using: Self.encoder)
        }
    }
}

enum MovieDetailAPI: APIRouter {
    struct GetMovieDetail: Encodable {
        let movieId: Int
    }

    case getMovieDetail(info: GetMovieDetail)
    
    var method: HTTPMethod {
        switch self {
        case .getMovieDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMovieDetail(let info):
            return "/movie/\(info.movieId)"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getMovieDetail:
            return [:]
        }
    }
}

protocol MovieAPIProvider {
    func request(_ api: MoviesAPI) -> AnyPublisher<[Movie], Error>
    func requestDetail(_ api: MovieDetailAPI) -> AnyPublisher<Movie?, Error>
}

final class MovieAPIClient: MovieAPIProvider {
    func request(_ api: MoviesAPI) -> AnyPublisher<[Movie], Error> {
        Deferred {
            Future { promise in
                AF.request(api).validate().responseDecodable(of: MoviesResponse.self) { response in
                    if let error = response.error {
                        promise(.failure(error))
                    } else {
                        promise(.success(response.value?.results ?? [Movie]()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestDetail(_ api: MovieDetailAPI) -> AnyPublisher<Movie?, Error> {
        Deferred {
            Future { promise in
                AF.request(api).validate().responseDecodable(of: Movie.self) { response in
                    if let error = response.error {
                        promise(.failure(error))
                    } else {
                        promise(.success(response.value))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
