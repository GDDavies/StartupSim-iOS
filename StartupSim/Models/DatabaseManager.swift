//
//  DatabaseManager.swift
//  StartupSim
//
//  Created by George Davies on 30/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct DatabaseManager {
    static func saveContext(context: NSManagedObjectContext) -> Error? {
        do {
            try context.save()
            DateManager.startDate = Date()
            return nil
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return error
        }
    }
    
    static func doFetchRequest(entity: String, context: NSManagedObjectContext) -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        do {
            let fetchedArray = try context.fetch(fetchRequest)
                return fetchedArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
