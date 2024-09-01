//
//  CurrentForecastViewModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation
import Combine


enum CurrentForecastState: Equatable {
    case fetching
    case error
    case result(CurrentForecast)
}

///   
final class CurrentForecastViewModel: ObservableObject {
    var locationTracker: CurrentLocationPublisher
    let dataManager: CurrentForecastManagable
    @Published var viewState: CurrentForecastState = .result(CurrentForecast())
    
    
    private var subscriptions: Set<AnyCancellable> = .init()

    init(_ locationTracker: CurrentLocationPublisher, dataManager: CurrentForecastManagable = CurrentForecastDataManager()) {
        self.locationTracker = locationTracker
        self.dataManager = dataManager
        
        self.subscribeForLocationChange()
    }
   
    /// get the last searched location from the api on the screen
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
    
    /// get the forecast of the searched location
    /// - Parameter location: 
    func fetchWeather(for location: TargetLocation) {
        self.viewState = .fetching
        Task {
            do {
                let newState: CurrentForecastState = .result(.init(try await self.dataManager.fetchCurrentWeather(for: location)))
                await MainActor.run {
                    self.viewState = newState
                }
            } catch {
                await MainActor.run {
                    self.viewState = .error
                }
            }
            
        }
    }
}
