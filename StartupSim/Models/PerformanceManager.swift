//
//  PerformanceManager.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct Inflation {
    static var rate = 1.00
}

struct PerformanceManager {
    static func continueOneWeek(context: NSManagedObjectContext) {
        
    }
    
    static func getAnnualPerformance() {
        
    }
}

struct DateManager {
    
    static let defaults = {
        return UserDefaults.standard
    }
    
    static var startDate: Date? {
        get {
            return DateManager.defaults().object(forKey: "startDate") as? Date
        }
        set {
            if self.startDate == nil {
                DateManager.defaults().set(newValue, forKey: "startDate")
                DateManager.defaults().set(newValue, forKey: "currentDate")
            }
        }
    }
    
    static var currentCalendar: Calendar {
        get {
            return Calendar.current
        }
    }
    
    static var currentDate: Date? {
        get {
            return defaults().object(forKey: "currentDate") as? Date
        }
    }
    
    static func incrementDate() {
        let nextWeek = currentCalendar.date(byAdding: .day, value: 7, to: currentDate!)
        defaults().set(nextWeek, forKey: "currentDate")
    }
}
