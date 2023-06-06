//
//  RootViewModel.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

class RootViewModel: NSObject {
    
    // MARK: - Types
    
    enum WeatherDataResult {
        case success(WeatherData)
        case failure(WeatherDataError)
    }
    
    enum WeatherDataError: Error {
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailable
    }
    
    // MARK: - Type Aliases
    
    typealias FetchWeatherDataCompletion = (WeatherDataResult) -> Void
    
    // MARK: - Properties
    
    var didFetchWeatherData: FetchWeatherDataCompletion?

    // MARK: -
    
    private let locationService: LocationService
    
    // MARK: - Initialization
    
    init(locationService: LocationService) {
        // Set Location Service
        self.locationService = locationService
        
        super.init()
        
        // Fetch Weather Data
        fetchWeatherData(for: Defaults.location)
        
        // Setup Notification Handling
        setupNotificationHandling()

        // Fetch Location
        fetchLocation()
    }
    
    // MARK: - Helper Methods
    
    private func fetchLocation() {
        locationService.fetchLocation { [weak self] (result) in
            switch result {
            case .success(let location):
                // Fetch Weather Data
                self?.fetchWeatherData(for: location)
            case .failure(let error):
                print("Unable to Fetch Location (\(error))")
                
                // Weather Data Result
                let result: WeatherDataResult = .failure(.notAuthorizedToRequestLocation)
                
                // Invoke Completion Handler
                self?.didFetchWeatherData?(result)
            }
        }
    }
    
    private func fetchWeatherData(for location: Location) {
        // Initialize Weather Request
        let weatherRequest = WeatherRequest(baseUrl: WeatherService.authenticatedBaseUrl, location: location)
        
        // Create Data Task
        URLSession.shared.dataTask(with: weatherRequest.url) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to Fetch Weather Data \(error)")
                    
                    // Weather Data Result
                    let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                    
                    // Invoke Completion Handler
                    self?.didFetchWeatherData?(result)
                } else if let data = data {
                    // Initialize JSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Configure JSON Decoder
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        // Decode JSON Response
                        let darkSkyResponse = try decoder.decode(DarkSkyResponse.self, from: data)
                        
                        // Weather Data Result
                        let result: WeatherDataResult = .success(darkSkyResponse)
                        
                        // Update User Defaults
                        UserDefaults.didFetchWeatherData = Date()
                        
                        // Invoke Completion Handler
                        self?.didFetchWeatherData?(result)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                        
                        // Weather Data Result
                        let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                        
                        // Invoke Completion Handler
                        self?.didFetchWeatherData?(result)
                    }
                } else {
                    // Weather Data Result
                    let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                    
                    // Invoke Completion Handler
                    self?.didFetchWeatherData?(result)
                }
            }
        }.resume()
    }

    // MARK: -
    
    private func setupNotificationHandling() {
        // Application Will Enter Foreground
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            guard let didFetchWeatherData = UserDefaults.didFetchWeatherData else {
                self?.refresh()
                return
            }
            
            if Date().timeIntervalSince(didFetchWeatherData) > Configuration.refreshThreshold {
                self?.refresh()
            }
        }
    }

    // MARK: -
    
    private func refresh() {
        fetchLocation()
    }

}

extension UserDefaults {
    
    // MARK: - Types
    
    private enum Keys {
        static let didFetchWeatherData = "didFetchWeatherData"
    }
    
    // MARK: - Class Computed Properties
    
    fileprivate class var didFetchWeatherData: Date? {
        get {
            return UserDefaults.standard.object(forKey: Keys.didFetchWeatherData) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.didFetchWeatherData)
        }
    }
    
}
