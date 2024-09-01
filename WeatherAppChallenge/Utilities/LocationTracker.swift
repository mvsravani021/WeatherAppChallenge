//
//  LocationTracker.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

protocol CurrentLocationPublisher {
    var coordinatePublisher: Published<TargetLocation?>.Publisher { get }
    var isAuthorized: Bool { get }
    func requestUserAuthorizationForLocation()
    var currentLocation: TargetLocation? { get }
    func updateTargetLocation(_ location: TargetLocation, isFromSearch: Bool)
}

final class LocationTracker: NSObject, ObservableObject, CurrentLocationPublisher {
    @Published var currentLocation: TargetLocation?
    @Published var authorizationStatus: CLAuthorizationStatus? = .notDetermined
    private let locationManager = CLLocationManager()

    @AppStorage("lastLatitude") private var lastLatitude: Double?
    @AppStorage("lastLongitude") private var lastLongitude: Double?
    
    var coordinatePublisher: Published<TargetLocation?>.Publisher { $currentLocation }
    private var subscriptions: Set<AnyCancellable> = .init()

    private var cachedCoordinate: TargetLocation? {
        guard let lat = lastLatitude, let long = lastLongitude else {
            return nil
        }
        return TargetLocation(latitude: lat, longitude: long)
    }
    
    override init() {
        super.init()
        self.authorizationStatus = locationManager.authorizationStatus
        locationManager.stopUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        $currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                if self?.cachedCoordinate != location {
                    self?.updateTargetLocation(location)
                }
            }
            .store(in: &subscriptions)
    }
    
    func resetLocation() {
        let prevLoc = self.currentLocation ?? self.cachedCoordinate
        
        if (prevLoc != nil) {
            self.currentLocation = prevLoc
        }
        
    }
    
    func updateTargetLocation(_ location: TargetLocation, isFromSearch: Bool = false) {
        lastLatitude = location.latitude
        lastLongitude = location.longitude
        
        if self.currentLocation != location {
            self.currentLocation = location
            if isFromSearch {
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    var isLocationNotAvailable: Bool {
        cachedCoordinate == nil
    }
    
    var requestForAuthorization: Bool {
        authorizationStatus == .notDetermined
    }
    
    func requestCurrentLocation() {
        if let cachedCoordinate {
            self.updateTargetLocation(cachedCoordinate)
        }else {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            self.requestUserAuthorizationForLocation()
        }
    }
    
    func requestUserAuthorizationForLocation() {
        if requestForAuthorization {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationTracker: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            self.currentLocation = nil
        default:
            break
        }
        authorizationStatus = manager.authorizationStatus
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate, self.cachedCoordinate != coordinate.targetLocation {
            self.currentLocation = coordinate.targetLocation
        } else if self.currentLocation == nil {
            self.currentLocation = self.cachedCoordinate
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if self.currentLocation == nil, self.cachedCoordinate != nil {
            self.currentLocation = self.cachedCoordinate
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude.roundedDegrees == rhs.latitude.roundedDegrees &&
            lhs.longitude.roundedDegrees == rhs.longitude.roundedDegrees
    }
    
    var targetLocation: TargetLocation {
        TargetLocation(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationDegrees {
    var roundedDegrees: String {
        self.formatted(
            .number
                .precision(.significantDigits(4))
                .rounded(rule: .down)
        )
    }
}
