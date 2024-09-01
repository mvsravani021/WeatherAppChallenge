//
//  CurrentForecastModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation


struct CurrentForecastModel: Decodable {
    let name: String
    let main: WeatherMainModel
    let weather: [WeatherStatusModel]
}

struct WeatherMainModel: Decodable {
    let temperature: Double?
    let minTemp: Double?
    let maxTemp: Double?
    let feelsLike: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case feelsLike = "feels_like"
    }
}

struct WeatherStatusModel: Decodable {
    let status: String?
    let icon: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "main"
        case icon
        case description
    }
}

struct CurrentForecast: Hashable {
    
    /// to check whether the temperature and name of the city are same or not.
    /// - Parameters:
    ///   - lhs:values of the forecast
    ///   - rhs: values of the forecast
    /// - Returns: whether the forecast has same temperature or not
    static func == (lhs: CurrentForecast, rhs: CurrentForecast) -> Bool {
        lhs.name == rhs.name && lhs.temperature == rhs.temperature
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(name)
        hasher.combine(temperature)
    }
    
    let dataModel: CurrentForecastModel?
    
    init(_ dataModel: CurrentForecastModel? = nil) {
        self.dataModel = dataModel
    }
    
    var name: String {
        self.dataModel?.name ?? Constants.defaultText
    }
    
    var temperature: String {
        guard let temp = self.dataModel?.main.temperature else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var feelsLikeTemp: String {
        guard let temp = self.dataModel?.main.feelsLike else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var status: String {
        self.dataModel?.weather.first?.status ?? Constants.defaultText
    }
    
    var statusIcon: String? {
        self.dataModel?.weather.first?.icon
    }
}
