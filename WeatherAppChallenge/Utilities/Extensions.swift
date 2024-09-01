//
//  Extensions.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation

extension Data {
    func decoded<T: Decodable>() throws -> T {
        try JSONDecoder()
            .decode(T.self, from: self)
    }
}

extension URLQueryItem {
    static func apiKey() -> Self {
        .init(name: "appid", value: Constants.apiKey)
    }
    
    static func latitude(_ lat: Double) -> Self {
        .init(name: "lat", value: "\(lat)")
    }
    
    static func longitude(_ long: Double) -> Self {
        .init(name: "lon", value: "\(long)")
    }
    
    static func unit() -> Self {
        .init(name: "units", value: "imperial")
    }
    
    static func limit(_ limit: Int) -> Self {
        .init(name: "cnt", value: "\(limit)")
    }
    
    static func limitResults(_ limit: Int) -> Self {
        .init(name: "limit", value: "\(limit)")
    }
    
    static func locationQuery(_ text: String) -> Self {
        .init(name: "q", value: "\(text)")
    }
}

extension TimeInterval {
    var time: String {
        let date = Date(timeIntervalSince1970: self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        var time = dayTimePeriodFormatter.string(from: date)
        if time.hasPrefix("0") {
            time = String(time[time.index(time.startIndex, offsetBy: 1)...])
        }
        return time
    }
    
    var hour: String {
        let date = Date(timeIntervalSince1970: self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh a"
        var hour = dayTimePeriodFormatter.string(from: date)
        if hour.hasPrefix("0") {
            hour = String(hour[hour.index(hour.startIndex, offsetBy: 1)...])
        }
        return hour
    }
    
    var day: String {
        let date = Date(timeIntervalSince1970: self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MM/dd"
        return dayTimePeriodFormatter.string(from: date)
    }
}
