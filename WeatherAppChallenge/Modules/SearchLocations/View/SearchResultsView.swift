//
//  SearchResultsView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchResultsViewModel
    
    var body: some View {
        switch viewModel.viewState {
        case .initial:
            EmptyView()
        case .fetching:
            ProgressView()
                .tint(.black)
        case .error:
            Text("Network Error. Please try again")
                .textStyle(.error)
        case .result(let locations):
            List {
                ForEach(locations) { searchLocation in
                    Button(action: {
                        viewModel.locationTracker.updateTargetLocation( TargetLocation(latitude: searchLocation.lat, longitude: searchLocation.long), isFromSearch: true)
                        dismiss()
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(searchLocation.name)
                                    .font(.title2)
                                Text(searchLocation.state)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .foregroundColor(.black)
                    })
                    
                }
            }
        }
        
    }
}

#Preview {
    SearchResultsView(viewModel: SearchResultsViewModel(LocationTracker()))
}
