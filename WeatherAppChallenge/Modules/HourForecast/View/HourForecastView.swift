//
//  HourForecastView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import SwiftUI

struct HourForecastView: View {
    @StateObject var viewModel: HourForecastViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "clock")
                        .renderingMode(.template)
                        .tint(.white)
                    Text(Constants.hourForecastTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                Divider()
                    .background(.white)
            }
            .padding()
            switch viewModel.viewState {
            case .fetching:
                ProgressView()
                    .tint(.white)
                    .padding(.vertical, 8.0)
            case .error:
                Text("Network Error. Please retry")
                    .textStyle(.error)
            case .result(let hourForecasts):
                HourScrollView(hourForecasts: hourForecasts)
                    .padding(.bottom, 8.0)
            }
        }
        .onAppear {
            if let target = viewModel.locationTracker.currentLocation {
                self.viewModel.fetchWeather(for: target)
            }
        }
        .background {
            Color.black.opacity(0.3)
                .cornerRadius(10.0)
        }
        .foregroundStyle(.white)
        .padding()
    }
}

struct HourScrollView: View {
    let hourForecasts: [HourForecast]
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24.0) {
                    ForEach(hourForecasts) { forecast in
                        HourDetailView(forecast: forecast)
                    }
                }
            }
        }
        .padding()
    }
}

struct HourDetailView: View {
    let forecast: HourForecast
    @State var showDetails: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            Text(forecast.hour)
            
            if let icon = forecast.statusIcon {
                WeatherIconView(icon: icon)
            }
            Text(forecast.temperature)
        }
        .onTapGesture {
            showDetails.toggle()
        }
        .sheet(isPresented: $showDetails) {
            VStack(alignment: .leading) {
                Text(forecast.statusMessage.capitalized + " at \(forecast.hour)")
                    .fontWeight(.bold)
                
                List {
                    DetailView(title: "Feels Like", value: forecast.feelsLikeTemp)
                    DetailView(title: "Min Temp", value: forecast.minTemp)
                    DetailView(title: "Max Temp", value: forecast.maxTemp)
                }
            }
            .padding()
            .textStyle(.details)
            .presentationDetents([.medium])
        }
        
    }

}

#Preview {
    HourForecastView(viewModel: HourForecastViewModel(LocationTracker()))
}
