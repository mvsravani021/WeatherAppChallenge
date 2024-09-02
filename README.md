# WeatherAppChallenge

This weather app is built to mimic iPhone's weather app for below features
  * Current forecast
  * Hourly forecast for 24 hours from current hour
  * 10-day forecast

Project is built with MVVM SwiftUI using Combine

## MVVM
To create home screen, divided screen into 4 modules. Followed MVVM for each module
  * Current Forecast - Top section that displays City name, temperature and weather status with icon
  * Hour Forecast - Horizontal scroll that displays hour forecast for 24 hrs from the current hour
  * 10-day forecast - vertical scroll list that displays min and max temperatures for the day
  * Navigation toolbar
      * Search - Sheet is presented with search bar to type city name and select location
      * Location - Get current location of device and fetch weather
      
## Location Tracker
Created Location Tracker to request device location permissions to display current forecast of device location.
Location Tracker implements the _CurrentLocationPublisher_ protocol.
```swift
      protocol CurrentLocationPublisher {
          var coordinatePublisher: Published<TargetLocation?>.Publisher { get }
          var isAuthorized: Bool { get }
          func requestUserAuthorizationForLocation()
          var currentLocation: TargetLocation? { get }
          func updateTargetLocation(_ location: TargetLocation, isFromSearch: Bool)
      }
```
Target location is a struct with lat and long coordinates for which forecast is fetched. Location can be device location or selected location from search.

```swift
        struct TargetLocation: Equatable {
            let latitude: Double
            let longitude: Double
        }
```
This struct helps not to import CoreLocation to access Coordinate.




