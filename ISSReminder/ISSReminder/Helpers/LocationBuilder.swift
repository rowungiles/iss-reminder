//
//  LocationBuilder.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationType = CLPlacemark

struct LocationBuilder {
    
    private let geocoder = CLGeocoder()

    static func makeLocation(label: String, placemark: LocationType, delegate: LocationDelegate) -> Location? {
        
        guard let lat = placemark.location?.coordinate.latitude,
            let lon = placemark.location?.coordinate.longitude,
            let location = Location(label: label, coordinates: Coordinates(latitude: lat, longitude: lon)) else {
                return nil
        }
        
        location.delegate = delegate
        
        return location
    }
    
    func findLocation(location: String, completion: @escaping (LocationType?) -> Void) {
        
        geocoder.geocodeAddressString(location, completionHandler: { (placemark, error) in
            
            // for brevity, I'm assuming there is a single result.
            // realistically there will be many results, none or an error and would need to be handled accordingly.
            
            completion(placemark?.first)
        })
    }
}
