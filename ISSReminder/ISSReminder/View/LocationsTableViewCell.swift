//
//  LocationsTableViewCell.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import UIKit

final class LocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var passTime: UILabel!
    
    static let identifier = String(describing: LocationsTableViewCell.self)
    
    func configure(location: Location) {
        
        passTime.text = location.nextRiseTime
        label.text = location.label
    }
    
    override func prepareForReuse() {
        
        label.text = ""
        passTime.text = ""
    }
}
