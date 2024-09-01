//
//  CurrentForecastViewModelTests.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import XCTest
@testable import WeatherAppChallenge

final class CurrentForecastViewModelTests: XCTestCase {
    let mockManager = MockCurrentForecastDataManager()
    let locationTracker = LocationTracker()

    lazy var viewModel: CurrentForecastViewModel = {
        CurrentForecastViewModel(locationTracker, dataManager: self.mockManager)
    }()
    
    func testInitialViewState() {
        XCTAssertNotEqual(viewModel.viewState, .fetching)
    }
    
    func testSuccessFetchResult() async {
        XCTAssertNotEqual(viewModel.viewState, .fetching)
        mockManager.mockType = .success
        locationTracker.updateTargetLocation(TargetLocation(latitude: 36.1443, longitude: -98.3222))
        sleep(6)
        XCTAssertEqual(viewModel.viewState, .result(.init(mockManager.mockCurrentForecast)))
    }
    
    func testFailureFetchResult() async {
        XCTAssertNotEqual(viewModel.viewState, .fetching)
        locationTracker.stopUpdatingLocation()
        mockManager.mockType = .failure
        locationTracker.updateTargetLocation(TargetLocation(latitude: 34.12443, longitude: -96.32322))
        sleep(6)
        XCTAssertEqual(viewModel.viewState, .error)
    }

}
