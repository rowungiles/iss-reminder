//
//  Serialisable.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import Foundation

protocol Serialisable {}

extension Serialisable {
    
    private var cachesDirectoryPath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    func archive(data: Any, pathExtension: String) {
        
        guard let cachesDirectoryPath = cachesDirectoryPath else {
            return
        }
        
        // synchronous and non-atomic - in production we'd have to take safe guards to not block the main thread and not run into atomicity issues.
        NSKeyedArchiver.archiveRootObject(data, toFile: cachesDirectoryPath + pathExtension)
    }
    
    func unarchive<T>(pathExtension: String) -> T? {
        
        guard let cachesDirectoryPath = cachesDirectoryPath else {
            return nil
        }
        
        // synchronous and non-atomic - in production we'd have to take safe guards to not block the main thread and not run into atomicity issues.
        return NSKeyedUnarchiver.unarchiveObject(withFile: cachesDirectoryPath + pathExtension) as? T
    }
}
