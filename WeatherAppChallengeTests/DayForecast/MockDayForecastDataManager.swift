//
//  MockDayForecastDataManager.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
@testable import WeatherAppChallenge

class MockDayForecastDataManager: DayForecastManagable {
    var mockType: DataManagingMockType = .success
    
    let dayForecastRecords: [DayForecastModel] = [
        DayForecastModel(dt: 1725008400, sunrise: 1725008500, sunset: 1725009500, temp: WeatherDayTempModel(dayTemp: 69.78, nightTemp: 54.80, morningTemp: 64.0, eveTemp: 54.00, minTemp: 52.97, maxTemp: 74.67), weather: [WeatherStatusModel(status: "Rain", icon: "02d", description: "Light Rain")], feelsLike: WeatherFeelsLikeDayTempModel(dayTemp: 72.98, nightTemp: 68.89, morningTemp: 56.78, eveTemp: 58.78))
    ]
    
    func fetchDailyForecast(for location: TargetLocation) async throws -> DayForecastResponseModel {
        switch mockType {
        case .success:
            return DayForecastResponseModel(dayForecast: dayForecastRecords)
        case .failure:
            throw NetworkError.networkTimeOut
        }
    }
}
