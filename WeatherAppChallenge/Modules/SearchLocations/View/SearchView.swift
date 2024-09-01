//
//  SearchView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SearchResultsViewModel
    
    var body: some View {
        NavigationStack {
            SearchResultsView(viewModel: viewModel)
                .searchable(text: $viewModel.searchText, prompt: "Enter City Name")
                .navigationTitle("Search Location")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchResultsViewModel(LocationTracker()))
}
