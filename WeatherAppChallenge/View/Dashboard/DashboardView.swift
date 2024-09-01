//
//  DashboardView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var locationTracker: LocationTracker
    var body: some View {
        ScrollView(showsIndicators: false) {
            if locationTracker.isLocationNotAvailable {
                Text(locationTracker.isAuthorized ? Constants.noLocationWithAccess : Constants.locationNotAuthorized)
                    .textStyle(.description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 200)
            } else {
                CurrentForecastView(viewModel: CurrentForecastViewModel( locationTracker))
                HourForecastView(viewModel: HourForecastViewModel(locationTracker))
                DayForecastView(viewModel: DayForecastViewModel(locationTracker))
            }
        }
        .refreshable {
            locationTracker.resetLocation()
        }
    }
}

#Preview {
    DashboardView(locationTracker: LocationTracker())
}
