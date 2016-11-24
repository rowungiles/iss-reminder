//
//  AddLocationViewController.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import UIKit

protocol AddLocationViewControllerDelegate: class {
    func addLocation(vc: AddLocationViewController, didFindLocation name: String, placemark: LocationType)
}

final class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    static let identifier = String(describing: AddLocationViewController.self)
    
    weak var delegate: AddLocationViewControllerDelegate?
    
    @IBAction func done(_ sender: Any) {
        
        if let location = locationField.text, let name = nameField.text {
            
            let locationBuilder = LocationBuilder()

            // async operations ahead, should have UI denoting this for the user
            locationBuilder.findLocation(location: location, completion: { [weak self] placemark in

                guard let placemark = placemark, let `self` = self else {
                    return // UI behaviour to alert the user of an issue
                }
                
                self.delegate?.addLocation(vc: self, didFindLocation: name, placemark: placemark)
            })
        }
    }
}
