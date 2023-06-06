//
//  LocationService.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import Foundation

enum LocationServiceError: Error {
    case notAuthorizedToRequestLocation
}

enum LocationServiceResult {
    case success(Location)
    case failure(LocationServiceError)
}

protocol LocationService {
    
    // MARK: - Type Aliases
    
    typealias FetchLocationCompletion = (LocationServiceResult) -> Void
    
    // MARK: - Methods
    
    func fetchLocation(completion: @escaping FetchLocationCompletion)
    
}
