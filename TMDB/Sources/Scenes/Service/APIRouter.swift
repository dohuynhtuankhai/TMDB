//
//  APIRouter.swift
//  TMDB
//
//  Created by Huynh Tuan Khai Do on 22/09/2023.
//

import Foundation
import Alamofire

public protocol APIRouter: URLRequestConvertible {
    static var baseURL: URL { get }
    static var encoder: JSONEncoder { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters { get }
}

public extension APIRouter {
    static var baseURL: URL {
        guard let url = URL(string: "\(Config.baseApiUrl)/3") else {
            fatalError("Couldn't configure base url")
        }
        return url
    }
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Self.baseURL.asURL()
        let urlRequest = URLRequest(url: path.isEmpty ? url : url.appendingPathComponent(path))
        var param = parameters
        param["api_key"] = Config.apiKey
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: param)
    }

}
