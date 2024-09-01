//
//  MockHourForecastDataManager.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
@testable import WeatherAppChallenge

class MockHourForecastDataManager: HourForecastManagable {
    var mockType: DataManagingMockType = .success
  
    let hourForecastRecords: [HourForecastModel] = [
        HourForecastModel(dt: 1725008400, main: WeatherMainModel(temperature: 57.90, minTemp: 54.90, maxTemp: 62.3, feelsLike: 59.99), weather: [WeatherStatusModel(status: "Rain", icon: "02d", description: "Light Rain")]),
        HourForecastModel(dt: 1725008400, main: WeatherMainModel(temperature: 77.90, minTemp: 74.90, maxTemp: 82.3, feelsLike: 73.99), weather: [WeatherStatusModel(status: "Sunny", icon: "03d", description: "Pretty hot")]),
    ]
    
    func fetchHourlyForecast(for location: TargetLocation) async throws -> HourForecastResponseModel {
    
        switch mockType {
        case .success:
            return HourForecastResponseModel(hourForecast: hourForecastRecords)
        case .failure:
            throw NetworkError.networkTimeOut
        }
    }
}
