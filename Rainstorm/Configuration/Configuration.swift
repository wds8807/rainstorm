//
//  Configuration.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

enum Defaults {
    
    static let location = Location(latitude: 37.335114, longitude: -122.008928)
    
}

enum Configuration {
    
    static var refreshThreshold: TimeInterval {
        #if DEBUG
        return 60.0
        #else
        return 10.0 * 60.0
        #endif
    }
    
}

enum WeatherService {
    
    private static let apiKey = "42caecda8bf07ba802f1ec3b33b14f2d"
    private static let baseUrl = URL(string: "https://api.darksky.net/forecast/")!
    
    static var authenticatedBaseUrl: URL {
        return baseUrl.appendingPathComponent(apiKey)
    }
    
}
