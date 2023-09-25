//
//  MovieDatabaseModel.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation
import RealmSwift

class MovieDatabaseModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var posterPath: String = ""
    @Persisted var overview: String = ""
    @Persisted var title: String = ""
    @Persisted var releaseDate: String = ""
    @Persisted var voteAverage: Double = 0
    @Persisted var index: Int = 0
    @Persisted var query: String? = nil
    
    convenience init(_ model: Movie, index: Int = 0, query: String? = nil) {
        self.init()
        self.id = model.id
        self.overview = model.overview
        self.title = model.title
        self.releaseDate = model.releaseDate
        self.voteAverage = model.voteAverage
        self.index = index
        self.query = query
    }
}
