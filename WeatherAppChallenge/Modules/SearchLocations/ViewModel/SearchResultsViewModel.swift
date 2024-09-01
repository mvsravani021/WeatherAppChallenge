//
//  SearchResultsViewModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation
import Combine

enum SearchViewState: Equatable {
    case initial
    case fetching
    case error
    case result([SearchResult])
}

final class SearchResultsViewModel: ObservableObject {
    let dataManager: SearchManaging
    var locationTracker: CurrentLocationPublisher
    @Published var searchText: String = ""
    @Published var viewState: SearchViewState = .initial
    
    private var subscriptions: Set<AnyCancellable> = .init()

    init(_ locationTracker: CurrentLocationPublisher, dataManager: SearchManaging = SearchDataManager() ) {
        self.dataManager = dataManager
        self.locationTracker = locationTracker
        
        searchTextSubscriber()
    }
    
    func searchTextSubscriber() {
        $searchText
            .dropFirst()
            .filter { _ in self.searchText.isEmpty == false }
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] text in
                self?.fetchLocations(for: text)
            }
            .store(in: &subscriptions)
    }
    
    func fetchLocations(for text: String) {
        self.viewState = .fetching
        Task
        {
            do {
                let response = try await self.dataManager.fetchLocations(searchText: text)
                
                let results: [SearchResult] = response.map { .init($0)}
                
                await MainActor.run {
                    self.viewState = .result(results)
                }
            } catch {
                await MainActor.run {
                    self.viewState =  text.isEmpty ? .initial : .error
                }
            }
        }
    }
}
