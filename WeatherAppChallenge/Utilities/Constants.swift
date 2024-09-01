//
//  Constants.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation

struct Constants {
    static let defaultText = "--"
    static let locationDeniedMssg = "Location permissions are denied. Please enable location services in settings."
    static let shareLocationMssg = "Please Share your location to fetch your current location Weather"
    static let apiKey = "e750ee86f62a0230e6991e42c166ea78"
    static let weatherRequestURL = "https://api.openweathermap.org/data/2.5/weather"
    static let hourForecastURL = "https://pro.openweathermap.org/data/2.5/forecast/hourly"
    static let dailyForecastURL = "https://pro.openweathermap.org/data/2.5/forecast/daily"
    static let locationSearchURL = "https://api.openweathermap.org/geo/1.0/direct"
    static let iconURL = "https://openweathermap.org/img/wn/"
    static let networkError = "Unable to fetch Weather. Please retry with different city."
    static let searchLimit = 10
    static let locationNotAuthorized = "Please accept location permissions or search for a location to view Weather"
    static let noLocationWithAccess = "Location Permission is set but location is not found. \n\n Please select location from search or simulate location for simulator"
    static let dayForecastTitle = "10 Day Forecast".capitalized
    static let hourForecastTitle = "Hourly Forecast".capitalized
}
