//
//  DayForecastDataManager.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation

protocol DayForecastManagable {
    func fetchDailyForecast(for location: TargetLocation) async throws -> DayForecastResponseModel
}


final class DayForecastDataManager: DayForecastManagable {
    
    /// Gets the forecast of the selected location for previous 10 days
    /// - Parameter location:get the location of the forecast that we are looking for
    /// - Returns: forecast temperature of the selected location for last 10 days
    func fetchDailyForecast(for location: TargetLocation) async throws -> DayForecastResponseModel {
        
    
        let requestClient = WeatherRequest(url: Constants.dailyForecastURL, queryParameters: [
            .apiKey(),
            .latitude(location.latitude),
            .longitude(location.longitude),
            .unit(),
            .limit(10)
        ])
        
        let forecast: DayForecastResponseModel = try await requestClient.executeRequest()
        
        return forecast
    }
}
