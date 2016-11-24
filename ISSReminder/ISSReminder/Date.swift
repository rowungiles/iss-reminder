//
//  Date.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import Foundation

extension Date {
    
    static let localMediumFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
    }()
}
