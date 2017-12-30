//
//  StartupManager.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct StartupMethods {
    
    static func createStartup(name: String, context: NSManagedObjectContext) {
        let startup = Startup(context: context)
        startup.name = name
        DatabaseManager.saveContext(context: context)
    }
    
    static func getStartupName(context: NSManagedObjectContext) -> String? {
        let request: NSFetchRequest<Startup> = Startup.fetchRequest()
        do {
            let result = try context.fetch(request) as [NSManagedObject]
            let startupName = result.first?.value(forKey: "name") as? String
            return startupName
        } catch {
            print(error)
            return nil
        }
    }
}
