//
//  LocationsTableViewController.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import UIKit

final class LocationsTableViewController: UITableViewController, Serialisable {

    fileprivate enum Archive: String {
        case path = "/locations"
    }
    
    fileprivate var locations = [Location]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let locations: [Location] = unarchive(pathExtension: Archive.path.rawValue) {
            
            self.locations = locations
            
            refreshLocations(self)
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        let vc = UIStoryboard.instantiateAddLocationsViewController()
        vc.delegate = self
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Location.Observer.name.rawValue), object: self)
    }
}

extension LocationsTableViewController: AddLocationViewControllerDelegate {

    func addLocation(vc: AddLocationViewController, didFindLocation name: String, placemark: LocationType) {
        
        vc.dismiss(animated: true, completion: nil)
        
        // it'd be extraordinary if location didn't exist, it would imply that the URL creation failed.
        // in that case, there ought to be some UI for the user.
    
        if let location = LocationBuilder.makeLocation(label: name, placemark: placemark, delegate: self) {
            
            locations.append(location)
            
            archive(data: locations, pathExtension: Archive.path.rawValue)
            
            location.updateNextRiseTime()
            
            tableView.reloadData()
        }
    }
}

extension LocationsTableViewController: LocationDelegate {
    
    func didUpdatePassTime(for location: Location, time: String) {
        
        archive(data: locations, pathExtension: Archive.path.rawValue)
        
        guard let row = locations.index(of: location) else {
            return
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension LocationsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsTableViewCell.identifier) as? LocationsTableViewCell else {
            fatalError("check cell identifier") // programmer error
        }
        
        cell.configure(location: locations[indexPath.row])
        
        return cell
    }
}
