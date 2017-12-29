//
//  EmployeeTableViewCell.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct EmployeeTableViewCellContent {
    var name: String?
    var role: String?
    var age: Int16?
    var salary: Int32?
    
    var creativityLevel: Int16?
    var businessLevel: Int16?
    var technicalLevel: Int16?
    
    var expanded: Bool
    
    init(employee: Person) {
        self.name = employee.name
        self.role = employee.role
        self.age = employee.age
        self.salary = employee.salary
        
        let skills = employee.skills?.allObjects.first as? Skills
        self.creativityLevel = skills?.creative
        self.businessLevel = skills?.business
        self.technicalLevel = skills?.technical
        
        self.expanded = false
    }
}

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    
    @IBOutlet weak var creativityLbl: UILabel!
    @IBOutlet weak var businessLbl: UILabel!
    @IBOutlet weak var technicalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
    }
    
    func setup(content: EmployeeTableViewCellContent) {
        nameLbl.text = content.name
        roleLbl.text = content.role
        if let age = content.age {
            ageLbl.text = "Age: \(age.description)"
        }
        salaryLbl.text = "Salary: £\(Strings.formatSalary(salary: content.salary!))"
        
        creativityLbl.text = content.creativityLevel?.description
        businessLbl.text = content.businessLevel?.description
        technicalLbl.text = content.technicalLevel?.description
    }
}
