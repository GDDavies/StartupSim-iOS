//
//  EntityManager.swift
//  StartupSim
//
//  Created by George Davies on 27/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import Foundation
import CoreData
import Fakery
import GameKit

enum Role: String {
    case softwareDeveloper = "Software Developer"
    case designer = "Designer"
    case projectManager = "Project Manager"
    case CEO = "CEO"
    case CTO = "CTO"
    //case secretary = "Secretary"
    case productManager = "Product Manager"
    case accountManager = "Account Manager"
    case marketingExecutive = "Marketing Executive"
    case COO = "COO"
}

struct PeopleMethods {
    
    static func createCEO(name: String, context: NSManagedObjectContext) {
        // Guard check if CEO already exists
        let ceo = Person(context: context)
        ceo.name = name
        ceo.role = "CEO"
        ceo.equity = 1.00
        let skills = createSkills(role: .designer, context: context)
        ceo.addToSkills(skills.object as! Skills)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func createEmployee(role: Role, context: NSManagedObjectContext) -> Person {
        let generate = Faker(locale: "en-GB")
        let employee = Person(context: context)
        employee.name = "\(generate.name.firstName()) \(generate.name.lastName())"
        employee.role = role.rawValue
        employee.negotiation = Int16(generate.number.randomInt(min: 0, max: 20))
        let skills = createSkills(role: role, context: context)
        employee.level = Int16(skills.totalLevel)
        let maxAge = Int(round(skills.totalLevel + 10 * Float(arc4random()) /  Float(UInt32.max)))
        employee.age = Int16(generate.number.randomInt(min: 18, max: maxAge))
        employee.salary = createSalary(person: employee)
        employee.addToSkills(skills.object as! Skills)
        return employee
    }
    
    static func createSkills(role: Role, context: NSManagedObjectContext) -> (object: NSManagedObject, totalLevel: Float) {
        let skills = Skills(context: context)
        switch role {
        case .softwareDeveloper:
            skills.creative = randomLevel(min: 5, max: 20)
            skills.technical = randomLevel(min: 10, max: 20)
            skills.business = randomLevel(min: 5, max: 20)
        case .projectManager:
            skills.creative = randomLevel(min: 5, max: 20)
            skills.technical = randomLevel(min: 5, max: 20)
            skills.business = randomLevel(min: 10, max: 20)
        case .CEO:
            skills.creative = randomLevel(min: 10, max: 20)
            skills.technical = randomLevel(min: 10, max: 20)
            skills.business = randomLevel(min: 10, max: 20)
        case .CTO:
            skills.creative = randomLevel(min: 5, max: 20)
            skills.technical = randomLevel(min: 15, max: 20)
            skills.business = randomLevel(min: 10, max: 20)
        case .productManager:
            skills.creative = randomLevel(min: 6, max: 20)
            skills.technical = randomLevel(min: 6, max: 20)
            skills.business = randomLevel(min: 8, max: 20)
        case .accountManager:
            skills.creative = randomLevel(min: 5, max: 20)
            skills.technical = randomLevel(min: 0, max: 20)
            skills.business = randomLevel(min: 15, max: 20)
        case .marketingExecutive:
            skills.creative = randomLevel(min: 10, max: 20)
            skills.technical = randomLevel(min: 0, max: 20)
            skills.business = randomLevel(min: 10, max: 20)
        case .COO:
            skills.creative = randomLevel(min: 10, max: 20)
            skills.technical = randomLevel(min: 5, max: 20)
            skills.business = randomLevel(min: 15, max: 20)
        case .designer:
            skills.creative = randomLevel(min: 10, max: 20)
            skills.technical = randomLevel(min: 5, max: 20)
            skills.business = randomLevel(min: 5, max: 20)
        }
        return (skills, Float(skills.creative + skills.technical + skills.business))
    }
    
    static func createSalary(person: Person) -> Int32 {
        var upperRange: Double?
        switch person.role! {
        case "Designer":
            upperRange = Double(100000)
        default:
            upperRange = Double(50000)
        }
        let levelRatio = Double(person.level) / Double(60)
        let ageRatio = (Double(person.age) * 1.5) / 65
        let salary = Int32(upperRange! * levelRatio * ageRatio)
        return salary.round(salary, toNearest: 500)
    }
    
    static func randomLevel(min: Int = 0, max: Int = 20) -> Int16 {
        let random = GKRandomSource()
        let distribution = GKGaussianDistribution(randomSource: random, lowestValue: min, highestValue: max)
        return Int16(distribution.nextInt())
    }
}

struct StartupMethods {
    static func createStartup(name: String, context: NSManagedObjectContext) {
        let startup = Startup(context: context)
        startup.name = name
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func getStartupName(context: NSManagedObjectContext) -> String? {
        let request: NSFetchRequest<Startup> = Startup.fetchRequest()
        do {
            let result = try context.fetch(request) as [NSManagedObject]
            
            let startupName = result[6].value(forKey: "name") as? String
            
            return startupName
        } catch {
            print(error)
            return nil
        }
    }
}

struct Inflation {
    static var rate = 1.00
}

extension NSManagedObjectContext {
//    func createCEO(name: String, context: NSManagedObjectContext) {
//        // Guard check if CEO already exists
//        let ceo = Person(context: context)
//        ceo.name = name
//        let skills = createSkills(role: .designer, context: context)
//        ceo.addToSkills(skills.object as! Skills)
//    }
//
//    func createEmployee(role: Role, context: NSManagedObjectContext) {
//        let generate = Faker(locale: "en-GB")
//        let employee = Person(context: context)
//        employee.name = "\(generate.name.firstName()) \(generate.name.lastName())"
//        employee.role = role.rawValue
//        let skills = createSkills(role: role, context: context)
//        employee.level = Int16(skills.totalLevel)
//        let maxAge = Int(round(skills.totalLevel + 10 * Float(arc4random()) /  Float(UInt32.max)))
//        employee.age = Int16(generate.number.randomInt(min: 18, max: maxAge))
//        employee.addToSkills(skills.object as! Skills)
//    }
//
//    func createSkills(role: Role, context: NSManagedObjectContext) -> (object: NSManagedObject, totalLevel: Float) {
//        let skills = Skills(context: context)
//        switch role {
//        case .softwareDeveloper:
//            skills.creative = randomLevel(min: 5, max: 20)
//            skills.technical = randomLevel(min: 10, max: 20)
//            skills.business = randomLevel(min: 5, max: 20)
//        case .projectManager:
//            skills.creative = randomLevel(min: 5, max: 20)
//            skills.technical = randomLevel(min: 5, max: 20)
//            skills.business = randomLevel(min: 10, max: 20)
//        case .CEO:
//            skills.creative = randomLevel(min: 10, max: 20)
//            skills.technical = randomLevel(min: 10, max: 20)
//            skills.business = randomLevel(min: 10, max: 20)
//        case .CTO:
//            skills.creative = randomLevel(min: 5, max: 20)
//            skills.technical = randomLevel(min: 15, max: 20)
//            skills.business = randomLevel(min: 10, max: 20)
//        case .productManager:
//            skills.creative = randomLevel(min: 6, max: 20)
//            skills.technical = randomLevel(min: 6, max: 20)
//            skills.business = randomLevel(min: 8, max: 20)
//        case .accountManager:
//            skills.creative = randomLevel(min: 5, max: 20)
//            skills.technical = randomLevel(min: 0, max: 20)
//            skills.business = randomLevel(min: 15, max: 20)
//        case .marketingExecutive:
//            skills.creative = randomLevel(min: 10, max: 20)
//            skills.technical = randomLevel(min: 0, max: 20)
//            skills.business = randomLevel(min: 10, max: 20)
//        case .COO:
//            skills.creative = randomLevel(min: 10, max: 20)
//            skills.technical = randomLevel(min: 5, max: 20)
//            skills.business = randomLevel(min: 15, max: 20)
//        case .designer:
//            skills.creative = randomLevel(min: 10, max: 20)
//            skills.technical = randomLevel(min: 5, max: 20)
//            skills.business = randomLevel(min: 5, max: 20)
//        }
//        return (skills, Float(skills.creative + skills.technical + skills.business))
//    }
//
//    func randomLevel(min: Int = 0, max: Int = 20) -> Int16 {
//        let random = GKRandomSource()
//        let distribution = GKGaussianDistribution(randomSource: random, lowestValue: min, highestValue: max)
//        return Int16(distribution.nextInt())
//    }
}









