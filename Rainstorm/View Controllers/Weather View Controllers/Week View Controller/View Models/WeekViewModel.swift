//
//  WeekViewModel.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

struct WeekViewModel {
    
    // MARK: - Properties
    
    let weatherData: [ForecastWeatherConditions]
    
    // MARK: -
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    // MARK: - Methods
    
    func viewModel(for index: Int) -> WeekDayViewModel {
        return WeekDayViewModel(weatherData: weatherData[index])
    }
    
}
