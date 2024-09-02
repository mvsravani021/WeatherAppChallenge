//
//  DayForecastView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import SwiftUI

///  UI for day forecast
struct DayForecastView: View {
    @StateObject var viewModel: DayForecastViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar")
                        .renderingMode(.template)
                    Text(Constants.dayForecastTitle)
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
            case .result(let dayForecasts):
                DayForecastScrollView(dayForecasts: dayForecasts)
                    .padding(.bottom, 8.0)
            }
        }
        .onAppear {
            if let target = viewModel.locationTracker.currentLocation {
                self.viewModel.fetchDayWeather(for: target)
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

/// This is to show the forecast of the last 10 with a scrolling functionality
struct DayForecastScrollView: View {
    let dayForecasts: [DayForecast]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(dayForecasts) { forecast in
                DayForeCastDetailView(forecast: forecast)
            }
        }
    }
}

/// Details of the forecast like cloudy/rainy/sunny, temperature min&max, date
struct DayForeCastDetailView: View {
    let forecast: DayForecast
    @State var showDetails: Bool = false

    var body: some View {
        HStack {
            Text(forecast.day)
            Spacer()
            if let icon = forecast.statusIcon {
                WeatherIconView(icon: icon)
                Spacer()
            }
            
            Text("Min: \(forecast.minTemp)" + " - " + "Max: \(forecast.maxTemp)")
            
        }
        .textStyle(.dayTitle)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 0.0)
        .onTapGesture {
            showDetails.toggle()
        }
        .sheet(isPresented: $showDetails) {
            VStack(alignment: .leading) {
                Text(forecast.day + " - " + forecast.statusMessage.capitalized)
                    .fontWeight(.bold)
               
                List {
                    if let sunrise = forecast.sunrise {
                        DetailView(title: "Sunrise", value: sunrise)
                    }
                    
                    if let sunset = forecast.sunset {
                        DetailView(title: "Sunset", value: sunset)
                    }
                    
                    if let morningTemp = forecast.morningTemp {
                        DetailView(title: "Morning", value: morningTemp)
                    }
                    
                    if let eveTemp = forecast.eveTemp {
                        DetailView(title: "Evening", value: eveTemp)
                    }
                    
                    if let nightTemp = forecast.nightTemp {
                        DetailView(title: "Night", value: nightTemp)
                    }
                }
                .multilineTextAlignment(.leading)
                
            }
            .padding()
            .textStyle(.details)
            .presentationDetents([.medium])
        }
        
    }
        
}

struct DetailView: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}
#Preview {
    DayForecastView(viewModel: DayForecastViewModel(LocationTracker()))
}
