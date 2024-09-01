//
//  MockSearchDataManager.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
@testable import WeatherAppChallenge

enum DataManagingMockType {
    case success
    case failure
}

enum NetworkError: Error {
    case unknown
    case networkTimeOut
    case decodingError
}

class MockSearchDataManager: SearchManaging {
    var mockType: DataManagingMockType = .success

    let locations: [SearchModel] = [
        SearchModel(name: "Plano", state: "Texas", country: "US", lat: 33.0136764, lon: -96.6925096),
        SearchModel(name: "Plano", state: "Iowa", country: "US", lat: 40.7555649, lon: -93.046593),
        SearchModel(name: "Plano", state: nil, country: "HR", lat: 43.5503081, lon: 16.2766617),
        SearchModel(name: "Plano", state: "Illinois", country: "US", lat: 41.662877, lon: -88.5366814),
        SearchModel(name: "Plano", state: "Ohio", country: "US", lat: 39.4911692, lon: -83.2841561),
        
    ]
    func fetchLocations(searchText: String) async throws -> [SearchModel] {
        switch mockType {
        case .success:
            return locations
        case .failure:
            throw NetworkError.networkTimeOut
        }
    }
}
