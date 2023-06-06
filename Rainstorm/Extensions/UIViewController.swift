//
//  UIViewController.swift
//  Rainstorm
//
//  Created by Dongshuo Wu on 6/5/2023.
//

import UIKit

extension UIViewController {
    
    // MARK: - Static Properties
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
}
