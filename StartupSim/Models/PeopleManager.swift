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
        ceo.experience = SkillLevel.senior.rawValue
        createSkills(person: ceo, context: context, completion: { tuple in
            ceo.addToSkills(tuple.object as! Skills)
        })
    }
    
    static func createEmployee(role: Role, experience: String, context: NSManagedObjectContext) -> Person {
        let generate = Faker(locale: "en-GB")
        let employee = Person(context: context)
        employee.name = "\(generate.name.firstName()) \(generate.name.lastName().first!)."
        employee.role = role.rawValue
        employee.negotiation = Int16(generate.number.randomInt(min: 0, max: 20))
        employee.experience = experience
        employee.happiness = 70.0
        
        createSkills(person: employee, context: context, completion: { tuple in
            employee.level = Int16(tuple.totalLevel)
            employee.addToSkills(tuple.object as! Skills)
            employee.salary = createSalary(level: tuple.totalLevel)
        })

        return employee
    }

    static func createSkills(person: Person, context: NSManagedObjectContext, completion: @escaping ((object: NSManagedObject, totalLevel: Float)) -> Void) {
        
        var specialism: (creative: Int, tech: Int, bus: Int)?
        
        let skills = Skills(context: context)
        skills.businessProgress = 0
        skills.creativeProgress = 0
        skills.technicalProgress = 0
        
        switch Role(rawValue: person.role!) {
        case .softwareDeveloper?:
            specialism = (creative: 2, tech: 1, bus: 3)
        case .projectManager?:
            specialism = (creative: 3, tech: 2, bus: 1)
        case .CEO?:
            specialism = (creative: 1, tech: 1, bus: 1)
        case .CTO?:
            specialism = (creative: 2, tech: 1, bus: 2)
        case .productManager?:
            specialism = (creative: 2, tech: 2, bus: 1)
        case .accountManager?:
            specialism = (creative: 2, tech: 3, bus: 1)
        case .marketingExecutive?:
            specialism = (creative: 1, tech: 3, bus: 1)
        case .COO?:
            specialism = (creative: 3, tech: 2, bus: 1)
        case .designer?:
            specialism = (creative: 1, tech: 2, bus: 3)
        case .none:
            specialism = (1, 1, 1)
        }
        skills.creative = getLevel(experience: SkillLevel(rawValue: person.experience!)!, specialism: specialism!.creative)
        skills.technical = getLevel(experience: SkillLevel(rawValue: person.experience!)!, specialism: specialism!.tech)
        skills.business = getLevel(experience: SkillLevel(rawValue: person.experience!)!, specialism: specialism!.bus)
        completion((skills, Float(skills.creative + skills.technical + skills.business)))
    }
    
    static private func getLevel(experience: SkillLevel, specialism: Int) -> Int16 {

        let generate = Faker(locale: "en-GB")
//        var maxSalary = 100000
        var experiencePoints: Int?
        var specialismPoints: Int?
        
        switch experience {
        case .junior:
            experiencePoints = generate.number.randomInt(min: 1, max: 4)
        case .mid:
            experiencePoints = generate.number.randomInt(min: 5, max: 7)
        case .senior:
            experiencePoints = generate.number.randomInt(min: 8, max: 10)
        }
        
        switch specialism {
        case 3:
            specialismPoints = generate.number.randomInt(min: 1, max: 4)
        case 2:
            specialismPoints = generate.number.randomInt(min: 5, max: 7)
        case 1:
            specialismPoints = generate.number.randomInt(min: 8, max: 10)
        default:
            specialismPoints = generate.number.randomInt(min: 0, max: 10)
        }
        
        return Int16(experiencePoints! + specialismPoints!)
    }
    
    static func createSalary(level: Float) -> Int32 {
        let upperRange: Double = 100000
        let levelRatio = Double(level) / Double(60)
        let salary = Int32(upperRange * levelRatio)
        return salary.round(salary, toNearest: 500)
    }
    
    static func randomLevel(min: Int = 0, max: Int = 20) -> Int16 {
        if min == max {
            return Int16(min)
        }
        let random = Faker()
        return Int16(random.number.randomInt(min: min, max: max))
    }    
}

enum Skill: String {
    case business = "business"
    case creative = "creative"
    case technical = "technical"
}

enum SkillLevel: String {
    case senior = "senior"
    case mid = "midLevel"
    case junior = "junior"
}

enum Role: String {
    case softwareDeveloper = "Developer"
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







