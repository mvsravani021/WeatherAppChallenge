//
//  SearchDataManager.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation

protocol SearchManaging {
    func fetchLocations(searchText: String) async throws -> [SearchModel]
}

final class SearchDataManager: SearchManaging {
    func fetchLocations(searchText: String) async throws -> [SearchModel] {
        let request = WeatherRequest(url: Constants.locationSearchURL, queryParameters: [
            .apiKey(),
            .locationQuery(searchText),
            .limitResults(10)
        ])
        
        let resultsData: [SearchModel] = try await request.executeRequest()
        
        return resultsData
    }
}
