//
//  MoviesResponse.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
}
