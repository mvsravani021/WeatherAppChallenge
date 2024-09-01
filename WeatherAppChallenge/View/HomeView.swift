//
//  HomeView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/27/24.
//

import SwiftUI

///  view of the home screen search button,background 
struct HomeView: View {
    @State var showSearch: Bool = false
    @StateObject var locationTracker: LocationTracker = LocationTracker()
    
    var body: some View {
        ZStack {
            BackgroundView()
            DashboardView(locationTracker: locationTracker)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .tint(.white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    locationTracker.startUpdatingLocation()
                } label: {
                    Image(systemName: "location.fill")
                }
                .tint(.white)
            }
            
        }
        .onAppear {
            locationTracker.requestCurrentLocation()
        }
        .sheet(isPresented: $showSearch, content: {
            SearchView(viewModel: SearchResultsViewModel(locationTracker))
        })
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
