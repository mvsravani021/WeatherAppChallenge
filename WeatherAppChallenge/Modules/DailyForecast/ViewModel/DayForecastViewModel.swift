//
//  DayForecastViewModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
import Combine

enum DayForecastState: Equatable {
    case fetching
    case error
    case result([DayForecast])
}

final class DayForecastViewModel: ObservableObject {
    var locationTracker: CurrentLocationPublisher
    let dataManager: DayForecastManagable
    @Published var viewState: DayForecastState = .fetching
    
    private var subscriptions: Set<AnyCancellable> = .init()
    
    init(_ locationTracker: CurrentLocationPublisher, dataManager: DayForecastManagable = DayForecastDataManager()) {
        self.locationTracker = locationTracker
        self.dataManager = dataManager
        
        self.subscribeForLocationChange()
    }
    
    
    /// Subsciption for location changes(device location, search location)
    private func subscribeForLocationChange() {
        locationTracker.coordinatePublisher
            .dropFirst()
            .sink { [weak self] location in
                if let target = location {
                    self?.fetchDayWeather(for: target)
                }
            }
            .store(in: &subscriptions)
    }
    
    /// get the location of the forecast u want to see
    /// - Parameter location: forecast location
    func fetchDayWeather(for location: TargetLocation) {
        self.viewState = .fetching
        Task {
            do {
                let response = try await self.dataManager.fetchDailyForecast(for: location)
                
                let dayForecasts: [DayForecast] = response.dayForecast.map { .init($0)}
                
                await MainActor.run {
                    self.viewState = .result(dayForecasts)
                }
            } catch {
                await MainActor.run {
                    self.viewState = .error
                }
            }
        }
    }
}
