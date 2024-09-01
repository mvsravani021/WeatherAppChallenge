//
//  HourForecastViewMode.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import Foundation
import Combine

enum HourForecastState: Equatable {
    case fetching
    case error
    case result([HourForecast])
}

final class HourForecastViewModel: ObservableObject {
    var locationTracker: CurrentLocationPublisher
    let dataManager: HourForecastManagable
    @Published var viewState: HourForecastState = .fetching
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(_ locationTracker: CurrentLocationPublisher, dataManager: HourForecastManagable = HourForecastDataManager()) {
        self.locationTracker = locationTracker
        self.dataManager = dataManager
        
        self.subscribeForLocationChange()
    }

    private func subscribeForLocationChange() {
        locationTracker.coordinatePublisher
            .dropFirst()
            .sink { [weak self] location in
                if let target = location {
                    self?.fetchWeather(for: target)
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchWeather(for location: TargetLocation) {
        self.viewState = .fetching
        Task {
            do {
                let response = try await self.dataManager.fetchHourlyForecast(for: location)
                
                let hourForecasts: [HourForecast] = response.hourForecast.map { .init($0)}
                await MainActor.run {
                    self.viewState = .result(hourForecasts)
                }
            } catch {
                await MainActor.run {
                    self.viewState = .error
                }
            }
        }
    }
}
