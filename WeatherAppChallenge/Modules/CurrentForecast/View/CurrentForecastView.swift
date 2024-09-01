//
//  HeaderView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import SwiftUI
import CoreLocation

struct CurrentForecastView: View {
    @StateObject var viewModel: CurrentForecastViewModel
    var body: some View {
        VStack(alignment: .center) {
            switch viewModel.viewState {
            case .fetching:
                ProgressView()
                    .tint(.white)
            case .error:
                Text("Network Error. Please retry")
                    .textStyle(.error)
            case .result(let currentForecast):
                Text(currentForecast.name)
                    .textStyle(.title)
                
                HStack(spacing: 48.0) {
                    Text(currentForecast.temperature)
                        .textStyle(.temperature)
                    
                    VStack(spacing: 4.0) {
                        Text("feels like")
                            .textStyle(.subTitle)
                        Text(currentForecast.feelsLikeTemp)
                            .textStyle(.feelsLikeTemp)
                    }
                }
                
                HStack(spacing: 16.0) {
                    if let icon = currentForecast.statusIcon {
                        WeatherIconView(icon: icon)
                    }
                    Text(currentForecast.status)
                        .textStyle(.description)
                }
            }
        }
        .onAppear {
            
            if let target = viewModel.locationTracker.currentLocation {
                self.viewModel.fetchWeather(for: target)
            }
        }
    }
        
}

#Preview {
    CurrentForecastView(viewModel: CurrentForecastViewModel(LocationTracker(), dataManager: CurrentForecastDataManager()))
}
