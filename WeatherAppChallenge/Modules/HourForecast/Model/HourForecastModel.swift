//
//  HourForecastModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import Foundation

struct HourForecastModel: Decodable {
    let dt: TimeInterval?
    let main: WeatherMainModel
    let weather: [WeatherStatusModel]
}

struct HourForecastResponseModel: Decodable {
    let hourForecast: [HourForecastModel]
    
    enum CodingKeys: String, CodingKey {
        case hourForecast = "list"
    }
}

struct HourForecast: Identifiable, Hashable {
    static func == (lhs: HourForecast, rhs: HourForecast) -> Bool {
        lhs.hour == rhs.hour
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hour)
    }
    
    var id: String { hour }
    let dataModel: HourForecastModel
    
    init(_ dataModel: HourForecastModel) {
        self.dataModel = dataModel
    }
    
    var hour: String {
        dataModel.dt?.hour ?? Constants.defaultText
    }
    
    var day: String {
        dataModel.dt?.day ?? Constants.defaultText
    }
    
    var temperature: String {
        guard let temp = self.dataModel.main.temperature else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var feelsLikeTemp: String {
        guard let temp = self.dataModel.main.feelsLike else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var minTemp: String {
        guard let temp = self.dataModel.main.minTemp else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var maxTemp: String {
        guard let temp = self.dataModel.main.maxTemp else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°F"
    }
    
    var status: String {
        self.dataModel.weather.first?.status ?? Constants.defaultText
    }
    
    var statusMessage: String {
        self.dataModel.weather.first?.description ?? ""
    }
    
    var statusIcon: String? {
        self.dataModel.weather.first?.icon
    }
}
