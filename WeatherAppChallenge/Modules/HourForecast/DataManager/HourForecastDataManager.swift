//
//  HourForecastDataManager.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import Foundation

protocol HourForecastManagable {
    func fetchHourlyForecast(for location: TargetLocation) async throws -> HourForecastResponseModel
}

final class HourForecastDataManager: HourForecastManagable {
    func fetchHourlyForecast(for location: TargetLocation)  async throws -> HourForecastResponseModel {
        
        let requestClient = WeatherRequest(url: Constants.hourForecastURL, queryParameters: [
            .apiKey(),
            .latitude(location.latitude),
            .longitude(location.longitude),
            .unit(),
            .limit(24)
        ])
        
        let forecast: HourForecastResponseModel = try await requestClient.executeRequest()
        
        return forecast
    }
}
