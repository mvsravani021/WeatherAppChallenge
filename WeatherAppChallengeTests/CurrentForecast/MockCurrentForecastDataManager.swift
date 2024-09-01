//
//  MockCurrentForecastDataManager.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
@testable import WeatherAppChallenge

class MockCurrentForecastDataManager: CurrentForecastManagable {
    var mockType: DataManagingMockType = .success
    
    let mockCurrentForecast = CurrentForecastModel(name: "Plano", main: WeatherMainModel(temperature: 57.90, minTemp: 54.90, maxTemp: 62.3, feelsLike: 59.99), weather: [WeatherStatusModel(status: "Rain", icon: "02d", description: "Light Rain")])
    
    func fetchCurrentWeather(for location: TargetLocation) async throws -> CurrentForecastModel {
        switch mockType {
        case .success:
            return mockCurrentForecast
        case .failure:
            throw NetworkError.networkTimeOut
        }
    }

    
}
