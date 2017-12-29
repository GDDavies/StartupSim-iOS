//
//  PeopleManager.swift
//  StartupSim
//
//  Created by George Davies on 27/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import Foundation
import CoreData
import Fakery
import GameKit

struct PeopleMethods {
    
    static func createCEO(name: String, context: NSManagedObjectContext) {
        // Guard check if CEO already exists
        let ceo = Person(context: context)
        ceo.name = name
        ceo.role = "CEO"
        ceo.equity = 1.00
        let skills = createSkills(role: .designer, minSalary: nil, maxSalary: nil, context: context)
        ceo.addToSkills(skills.object as! Skills)
    }
    
    static func createEmployee(minSalary: Int32, maxSalary: Int32, role: Role, context: NSManagedObjectContext) -> Person {
        let generate = Faker(locale: "en-GB")
        let employee = Person(context: context)
        employee.name = "\(generate.name.firstName()) \(generate.name.lastName())"
        employee.role = role.rawValue
        employee.negotiation = Int16(generate.number.randomInt(min: 0, max: 20))
        let skills = createSkills(role: role, minSalary: Int(minSalary), maxSalary: Int(maxSalary), context: context)
        employee.level = Int16(skills.totalLevel)
        let maxAge = Int(round(skills.totalLevel + 10 * Float(arc4random()) /  Float(UInt32.max)))
        employee.age = Int16(generate.number.randomInt(min: 18, max: maxAge))
        employee.salary = createSalary(person: employee)
        employee.addToSkills(skills.object as! Skills)
        return employee
    }
    
    static func createSkills(role: Role, minSalary: Int?, maxSalary: Int?, context: NSManagedObjectContext) -> (object: NSManagedObject, totalLevel: Float) {
        let skills = Skills(context: context)
        skills.businessProgress = 0
        skills.creativeProgress = 0
        skills.technicalProgress = 0
        
        var creativeMin: Double?
        var creativeMax: Double?
        
        var technicalMin: Double?
        var technicalMax: Double?
        
        var businessMin: Double?
        var businessMax: Double?
        
        // Designer

        
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
            
            creativeMin = 30 * (Double(minSalary!) / 100000) < 20 ? 30 * (Double(maxSalary!) / 100000) : 20
            creativeMax = 20 * (Double(maxSalary!) / 100000) < 20 ? 20 * (Double(maxSalary!) / 100000) : 20

            technicalMin = 10 * Double(minSalary!) / 100000 < 10 ? 20 * Double(maxSalary!) / 100000 : 10
            technicalMax = 15 * Double(maxSalary!) / 100000 < 15 ? 20 * Double(maxSalary!) / 100000 : 15

            businessMin = 10 * Double(minSalary!) / 100000 < 10 ? 10 * Double(maxSalary!) / 100000 : 10
            businessMax = 15 * Double(maxSalary!) / 100000 < 15 ? 15 * Double(maxSalary!) / 100000 : 15
        }
        skills.creative = randomLevel(min: Int(creativeMin!), max: Int(creativeMax!))
        skills.technical = randomLevel(min: Int(technicalMin!), max: Int(technicalMax!))
        skills.business = randomLevel(min: Int(businessMin!), max: Int(businessMax!))
        return (skills, Float(skills.creative + skills.technical + skills.business))
    }
    
    static func createSalary(person: Person) -> Int32 {
        var upperRange: Double?
        switch person.role! {
        case "Designer":
            upperRange = Double(100000 * Inflation.rate)
        default:
            upperRange = Double(100000 * Inflation.rate)
        }
        let levelRatio = Double(person.level) / Double(60)
        //let ageRatio = (Double(person.age) * 1.2) / 65
        let salary = Int32(upperRange! * levelRatio)// * ageRatio)
        return salary.round(salary, toNearest: 500)
    }
    
    static func randomLevel(min: Int = 0, max: Int = 20) -> Int16 {
        let random = GKRandomSource()
        let distribution = GKGaussianDistribution(randomSource: random, lowestValue: min, highestValue: max)
        return Int16(distribution.nextInt())
    }
}

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







