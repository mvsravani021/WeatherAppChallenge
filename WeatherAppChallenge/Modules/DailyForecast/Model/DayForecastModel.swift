//
//  DayForecastModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation

///  Data for dailyForecast required to show on the screen
struct DayForecastModel: Decodable {
    let dt: TimeInterval?
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
    
    let temp: WeatherDayTempModel
    let weather: [WeatherStatusModel]
    let feelsLike: WeatherFeelsLikeDayTempModel?
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case dt
        case temp
        case weather
        case sunrise
        case sunset
    }
}

struct DayForecastResponseModel: Decodable {
    let dayForecast: [DayForecastModel]
    
    enum CodingKeys: String, CodingKey {
        case dayForecast = "list"
    }
}

struct WeatherDayTempModel: Decodable {
    let dayTemp: Double?
    let nightTemp: Double?
    let morningTemp: Double?
    let eveTemp: Double?
    let minTemp: Double?
    let maxTemp: Double?
    
    enum CodingKeys: String, CodingKey {
        case dayTemp = "day"
        case nightTemp = "night"
        case morningTemp = "morn"
        case eveTemp = "eve"
        case minTemp = "min"
        case maxTemp = "max"
    }
}

struct WeatherFeelsLikeDayTempModel: Decodable {
    let dayTemp: Double?
    let nightTemp: Double?
    let morningTemp: Double?
    let eveTemp: Double?
    
    enum CodingKeys: String, CodingKey {
        case dayTemp = "day"
        case nightTemp = "night"
        case morningTemp = "morn"
        case eveTemp = "eve"
    }
}

struct DayForecast: Identifiable, Hashable {
    var id: String { day }
    let dataModel: DayForecastModel
    
    init(_ dataModel: DayForecastModel) {
        self.dataModel = dataModel
    }
    
    var day: String {
        self.dataModel.dt?.day ?? Constants.defaultText
    }
    
    var sunrise: String? {
        self.dataModel.sunrise?.time
    }
    
    var sunset: String? {
        self.dataModel.sunset?.time
    }
    
    var statusIcon: String? {
        self.dataModel.weather.first?.icon
    }
    
    var status: String {
        self.dataModel.weather.first?.status ?? ""
    }
    
    var statusMessage: String {
        self.dataModel.weather.first?.description ?? ""
    }
    
    var minTemp: String {
        guard let temp = self.dataModel.temp.minTemp else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°"
    }
    
    var maxTemp: String {
        guard let temp = self.dataModel.temp.maxTemp else {
            return Constants.defaultText
        }
        
        return "\(Int(temp))" + "°"
    }
    
    var morningTemp: String? {
        guard let temp = self.dataModel.temp.morningTemp else {
            return nil
        }
        
        return "\(Int(temp))" + "°"
    }
    
    var nightTemp: String? {
        guard let temp = self.dataModel.temp.nightTemp else {
            return nil
        }
        
        return "\(Int(temp))" + "°"
    }
    
    var eveTemp: String? {
        guard let temp = self.dataModel.temp.eveTemp else {
            return nil
        }
        
        return "\(Int(temp))" + "°"
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(day)
    }
    
    static func == (lhs: DayForecast, rhs: DayForecast) -> Bool {
        return lhs.day == rhs.day
    }
}
