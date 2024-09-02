//
//  TargetLocation.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import Foundation

struct TargetLocation: Equatable {
    let latitude: Double
    let longitude: Double
    
    public static func == (lhs: TargetLocation, rhs: TargetLocation) -> Bool {
        return lhs.latitude.roundedDegrees == rhs.latitude.roundedDegrees &&
            lhs.longitude.roundedDegrees == rhs.longitude.roundedDegrees
    }
}
