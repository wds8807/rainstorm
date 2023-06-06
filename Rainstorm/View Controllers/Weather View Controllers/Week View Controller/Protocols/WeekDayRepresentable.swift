//
//  WeekDayRepresentable.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import UIKit

protocol WeekDayRepresentable {
    
    var day: String { get }
    var date: String { get }
    var temperature: String { get }
    var windSpeed: String { get }
    var image: UIImage? { get }
    
}
