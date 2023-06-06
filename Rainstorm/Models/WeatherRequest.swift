//
//  WeatherRequest.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

struct WeatherRequest {
    
    // MARK: - Properties
    
    let baseUrl: URL
    
    // MARK: -
    
    let location: Location
    
    // MARK: -
    
    var latitude: Double {
        return location.latitude
    }
    
    var longitude: Double {
        return location.longitude
    }
    
    // MARK: -
    
    var url: URL {
        return baseUrl.appendingPathComponent("\(latitude),\(longitude)")
    }
    
}
