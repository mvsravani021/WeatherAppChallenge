//
//  WeatherRequest.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case responseError
    case decodingError
}

protocol NetworkRequest {
    func executeRequest<T: Decodable>() async throws -> T
}

struct WeatherRequest: NetworkRequest {
    let url: String
    let queryParameters: [URLQueryItem]
    let urlSession: URLSession
    
    init(
        url: String,
        queryParameters: [URLQueryItem]
    ) {
        self.url = url
        self.queryParameters = queryParameters
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        self.urlSession = URLSession(configuration: config)
    }
    
    func executeRequest<T: Decodable>() async throws -> T {
        guard let request = self.prepareURLForRequest(url: url) else {
            throw NetworkError.urlError
        }
        let (data, response) = try await urlSession.data(for: request)
        
        let status = (response as? HTTPURLResponse)?.statusCode
        guard let status, status == 200 else {
            throw NetworkError.responseError
        }
        do {
            let decodedModel: T = try data.decoded()
            return decodedModel
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func prepareURLForRequest(url: String) -> URLRequest? {
        guard let relativeURL = URL(string: url) else { return nil }
        
        var urlcomponents = URLComponents()
        urlcomponents.queryItems = queryParameters
        guard let componentUrl = urlcomponents.url(relativeTo: relativeURL)
        else {
            return nil
        }
        
        var request = URLRequest(url: componentUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        return request
    }
}
