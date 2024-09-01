//
//  CurrentForecastDataManager.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation


protocol CurrentForecastManagable {
    func fetchCurrentWeather(for location: TargetLocation) async throws -> CurrentForecastModel
}

final class CurrentForecastDataManager: CurrentForecastManagable {
    
    /// To get the forecast of the present location
    /// - Parameter location: location yow want to know the forecast
    /// - Returns: forecast of the location mentioned
    func fetchCurrentWeather(for location: TargetLocation) async throws -> CurrentForecastModel {
        print("Fetching current forecast")
        let requestClient = WeatherRequest(url: Constants.weatherRequestURL, queryParameters: [
            .apiKey(),
            .latitude(location.latitude),
            .longitude(location.longitude),
            .unit()
        ])
        
        let forecast: CurrentForecastModel = try await requestClient.executeRequest()
        
        return forecast
    }
}
