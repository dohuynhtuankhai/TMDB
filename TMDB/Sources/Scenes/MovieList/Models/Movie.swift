//
//  Movie.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let posterPath: String
    let overview: String
    let title: String
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case title = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
    }
    
    init(_ dbModel: MovieDatabaseModel) {
        self.id = dbModel.id
        self.posterPath = dbModel.posterPath
        self.overview = dbModel.overview
        self.title = dbModel.title
        self.releaseDate = dbModel.releaseDate
        self.voteAverage = dbModel.voteAverage
    }
    
    init() {
        self.id = 0
        self.posterPath = ""
        self.overview = ""
        self.title = "Now or never"
        self.releaseDate = "Lat"
        self.voteAverage = 2.132
    }
}
