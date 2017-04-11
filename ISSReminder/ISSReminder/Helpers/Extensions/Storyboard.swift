//
//  Storyboard.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    private enum Storyboards: String {
        case Main
    }
    
    private enum StoryboardIdentifiers: String {
        case AddLocation = "AddLocationViewController"
    }
    
    private final class func instatiateStoryboard<T>(name: Storyboards, identifier: StoryboardIdentifiers) -> T {
        
        guard let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: identifier.rawValue) as? T else {
            fatalError("Unable to cast storyboard \(name) to type \(T.self).") // programmer error
        }
        
        return storyboard
    }
    
    final class func instantiateAddLocationsViewController<T: UIViewController>() -> T where T: AddLocationViewController {
        return instatiateStoryboard(name: .Main, identifier: .AddLocation)
    }
}
