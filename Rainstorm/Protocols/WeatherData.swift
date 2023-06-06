//
//  WeatherData.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

protocol WeatherData {
    
    var latitude: Double { get }
    var longitude: Double { get }
    
    var current: CurrentWeatherConditions { get }
    var forecast: [ForecastWeatherConditions] { get }
    
}

protocol WeatherConditions {
    
    var time: Date { get }
    var icon: String { get }
    var windSpeed: Double { get }
    
}

protocol CurrentWeatherConditions: WeatherConditions {
    
    var summary: String { get }
    var temperature: Double { get }
    
}

protocol ForecastWeatherConditions: WeatherConditions {
    
    var temperatureMin: Double { get }
    var temperatureMax: Double { get }
    
}
