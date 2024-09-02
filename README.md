# WeatherAppChallenge

This weather app is built to mimic iPhone's weather app for below features
  * Current forecast
  * Hourly forecast for 24 hours from current hour
  * 10-day forecast

Project is built with MVVM SwiftUI using Combine

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

Current Location is saved to SwiftUI _AppSettings_ to cache and retrieve it on launch of the application. Cache will be overridden on search of new location for weather.


## MVVM
To create home screen, divided screen into 4 modules. Followed MVVM for each module
  * Current Forecast - Top section that displays City name, temperature and weather status with icon
  * Hour Forecast - Horizontal scroll that displays hour forecast for 24 hrs from the current hour
  * 10-day forecast - vertical scroll list that displays min and max temperatures for the day
  * Navigation toolbar
      * Search - Sheet is presented with search bar to type city name and select location
      * Location - Get current location of device and fetch weather

Each module is created with MVVM structure. Has it's own dataManager, Model, viewModel and View.
ViewModule within the module subscribes to location changes either deviceLocation or selected location from search. Upon new location, viewModel fetches weather information and updates viewState. ViewState is a published var in viewModel. Upon change in viewState, view renders new data on the screen.

```swift
      locationTracker.coordinatePublisher
            .dropFirst()
            .sink { [weak self] location in
                if let target = location {
                    self?.fetchWeather(for: target)
                }
            }
            .store(in: &subscriptions)
```
## Networking
Created a protocol NetworkRequest to execute request to fetch data from OpenWeather API.
```swift
        protocol NetworkRequest {
            func executeRequest<T: Decodable>() async throws -> T
        }
```
WeatherRequest implements NetworkRequest to trigger API request. WeatherRequest initializer creates queryParams and url. UpOn executeRequest, prepares URLRequest for the scenario and triggers request.

Each Module has a protocol for dataManaging and protocol implementation (dataManager instance) is injected to viewModel via DependencyInjection
```swift
        protocol CurrentForecastManagable {
            func fetchCurrentWeather(for location: TargetLocation) async throws -> CurrentForecastModel
        }

        protocol SearchManaging {
            func fetchLocations(searchText: String) async throws -> [SearchModel]
        }

        protocol DayForecastManagable {
            func fetchDailyForecast(for location: TargetLocation) async throws -> DayForecastResponseModel
        }

        protocol HourForecastManagable {
            func fetchHourlyForecast(for location: TargetLocation) async throws -> HourForecastResponseModel
        }
```
## On Launch of the app
On Launch of the app, App checks if a cached location is available. If cache is not present, app tries to get location permissions from the user to present weather of the device location. 

If user denies the location permission, App displays below message on screen at the center
```
  Please accept location permissions or search for a location to view Weather
```

If location can't be retrieved after allowing user permissions, app displays below message
```
  Location Permission is set but location is not found. \n\n Please select location from search or simulate location for simulator
```

On success retrieve of the location, locationTracker updates currentLocation and saves same to cache. LocationTracker publishes the location, module subscribers would get update on the location and triggers API to retrieve data, renders UI on screen. If API fails, viewModel updates viewState to error and view displays error message.

On click of hour forecast or day forecast, tried to present bottom sheet with further details of the weather.

https://github.com/user-attachments/assets/bfe3cafe-d48a-4bf9-b743-e5440c2882ef

## Image Cache
ImageFetcher class is created to cache image with the associated iconName. WeatherIconView is created to trigger async api to fetch image if cached image is not available. Upon successful fetch, ImageFetcher adds image to cache
```swift
      protocol ImageCache {
          func image(for iconName: String) -> Image?
          func addImageToCache(_ image: Image,for iconName: String) -> Image
      }
```

## Search City name
Search is displayed on top right with magnifying lens. On click of search, searchBar is displayed as sheet presenter. On change of text within searchbar, api is triggered to get locations and list is displayed with cityname, state and country.

Upon selection of city, targetlocation is created with coordinate of the location and updates currentLocation within locationTracker to fetch new data and presents on the screen.

## Device Location
User can always check weather of the device location with location button on top left of the screen.
On click of location button, locationTracker fetches device location using CLLocationManager and updates currentLocation on successful retrieval of device location. All the module subscribers would get updated location and retrieves weather info to render data on the screen.

## Extensions
### URLQueryItem
Created static func to create query items for url to append apiKey, latLong and limit count
### TimeInterval
Created extensions for TimeInterval to convert timeInterval to time (hh:mm a), hour (hh a) and Day (MM/dd) formats
### View
Created a viewModifier to apply textFonts for 3 modules and used across. 
Created extension for View to apply style.

## Constants
Created a Struct _Constants_ to define all hardcoded constants including URLEndpoints.




