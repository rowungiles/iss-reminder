//
//  Location.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import UIKit

typealias Coordinates = (latitude: Double, longitude: Double)

protocol LocationDelegate: class {
    func didUpdatePassTime(for location: Location, time: String)
}

final class Location: NSObject, Networking {
    
    private enum API: String {
        // ATS exception required
        case url = "http://api.open-notify.org/iss-pass.json?"
        case lat = "lat="
        case long = "&lon="
        
        static func makeURL(latitude: Double, longitude: Double) -> String {
            return "\(url.rawValue)\(lat.rawValue)\(latitude)\(long.rawValue)\(longitude)"
        }
    }
    
    fileprivate enum JSONKeys: String {
        case response
        case risetime
    }
    
    fileprivate enum SerialisationKeys: String {
        case label
        case nextRiseTime
        case lat
        case long
    }
    
    enum Observer: String {
        case name = "com.rowungiles.iss-reminder"
    }
    
    fileprivate let passURL: URL
    
    fileprivate var inflightTask: URLSessionDataTask?
    
    let label: String
    let coordinates: Coordinates
    
    var nextRiseTime: String? = "calculating..." {
        
        didSet {
            if let newValue = nextRiseTime, newValue != oldValue {
                delegate?.didUpdatePassTime(for: self, time: newValue)
            }
        }
    }

    weak var delegate: LocationDelegate?

    init?(label: String, coordinates: Coordinates) {
        
        guard let passURL = URL(string: API.makeURL(latitude: coordinates.latitude, longitude: coordinates.longitude)) else {
            return nil
        }
        
        self.passURL = passURL
        self.label = label
        self.coordinates = coordinates
        
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateNextRiseTime),
                                               name: NSNotification.Name(rawValue: Observer.name.rawValue),
                                               object: nil)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        
        guard let label = decoder.decodeObject(forKey: SerialisationKeys.label.rawValue) as? String,
            let nextRiseTime = decoder.decodeObject(forKey: SerialisationKeys.nextRiseTime.rawValue) as? String else {
            
            return nil
        }
        
        let lat = decoder.decodeDouble(forKey: SerialisationKeys.lat.rawValue)
        let long = decoder.decodeDouble(forKey: SerialisationKeys.long.rawValue)
        
        let coordinates = Coordinates(latitude: lat, longitude: long)
        
        self.init(label: label, coordinates: coordinates)
        
        self.nextRiseTime = nextRiseTime
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Location {

    @objc func updateNextRiseTime() {
        
        inflightTask?.cancel()
        
        inflightTask = fetchData(at: passURL, completion: { [weak self] result in
        
            guard let `self` = self else {
                return
            }
            
            DispatchQueue.main.async {

                self.nextRiseTime = self.discoverRiseTime(from: result)
            }
        })
    }
    
    func discoverRiseTime(from result: NetworkingResult) -> String? {

        var nextRiseTime: String?
        
        switch result {
        case let .success(data):
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let dict = json as? [String : Any],
                let response = (dict[JSONKeys.response.rawValue] as? [[String : Any]])?.first,
                let risetime = response[JSONKeys.risetime.rawValue] as? Int64 {
                
                let date = Date(timeIntervalSince1970: Double(risetime))
                
                nextRiseTime = Date.localMediumFormatter.string(from: date)
            }
            
        case .error:
            break
        }
        
        return nextRiseTime
    }
}

extension Location: NSCoding {
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(label, forKey: SerialisationKeys.label.rawValue)
        aCoder.encode(coordinates.latitude, forKey: SerialisationKeys.lat.rawValue)
        aCoder.encode(coordinates.longitude, forKey: SerialisationKeys.long.rawValue)
        aCoder.encode(nextRiseTime, forKey: SerialisationKeys.nextRiseTime.rawValue)
    }
}

func ==(lhs: Location, rhs: Location) -> Bool {
    return (lhs.passURL.absoluteString == rhs.passURL.absoluteString) && (lhs.label == rhs.label)
}
