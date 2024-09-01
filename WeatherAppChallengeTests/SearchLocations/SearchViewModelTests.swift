//
//  SearchViewModelTests.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import XCTest
@testable import WeatherAppChallenge

final class SearchViewModelTests: XCTestCase {

    
    let mockManager: MockSearchDataManager = MockSearchDataManager()
    
    lazy var viewModel: SearchResultsViewModel = { SearchResultsViewModel(LocationTracker(), dataManager: self.mockManager)
    }()
    
    func testInitialViewState() {
        XCTAssertEqual(viewModel.viewState, .initial)
        XCTAssertEqual(viewModel.searchText, "")
    }

    func testSuccessFetchLocations() async {
        viewModel.searchText = "Plano"
        viewModel.fetchLocations(for: viewModel.searchText)
        XCTAssertEqual(viewModel.viewState, .fetching)
        sleep(4)
        XCTAssertEqual(viewModel.viewState, .result(mockManager.locations.map { SearchResult.init($0) }))
        
    }
    
    func testFailedFetchLocations() async {
        mockManager.mockType = .failure
        viewModel.searchText = "Plano"
        viewModel.fetchLocations(for: viewModel.searchText)
        XCTAssertEqual(viewModel.viewState, .fetching)
        sleep(4)
        XCTAssertEqual(viewModel.viewState, .error)
    }
    
    
}
