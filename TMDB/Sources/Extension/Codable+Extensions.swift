//
//  Codable+Extensions.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation

public extension Encodable {
    func asDictionary(using encoder: JSONEncoder = .init()) -> [String: Any] {
        do {
            let data = try encoder.encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                let className = String(describing: type(of: self))
                print("Failed to convert as dictionary for \(className)")
                return [:]
            }
            return dictionary
        } catch {
            print(error)
            return [:]
        }
    }
}
