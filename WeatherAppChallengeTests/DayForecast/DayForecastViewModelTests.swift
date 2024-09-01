//
//  DayForecastViewModelTests.swift
//  WeatherAppChallengeTests
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import XCTest
@testable import WeatherAppChallenge

final class DayForecastViewModelTests: XCTestCase {
    let mockManager = MockDayForecastDataManager()
    let locationTracker = LocationTracker()
    
    lazy var viewModel: DayForecastViewModel = {
        DayForecastViewModel(locationTracker, dataManager: mockManager)
    }()
    
    func testInitialViewState() {
        XCTAssertEqual(viewModel.viewState, .fetching)
    }

    func testSuccessFetchResult() async {
        mockManager.mockType = .success
        XCTAssertEqual(viewModel.viewState, .fetching)
        locationTracker.updateTargetLocation(TargetLocation(latitude: 36.1443, longitude: -98.3222))
        sleep(6)
        XCTAssertEqual(viewModel.viewState, .result(mockManager.dayForecastRecords.map { .init($0)}))
    }
    
    func testFailureFetchResult() async {
        mockManager.mockType = .failure
        XCTAssertEqual(viewModel.viewState, .fetching)
        locationTracker.updateTargetLocation(TargetLocation(latitude: 34.12443, longitude: -96.32322))
        XCTAssertEqual(viewModel.viewState, .fetching)
        sleep(6)
        XCTAssertEqual(viewModel.viewState, .error)
    }
}
