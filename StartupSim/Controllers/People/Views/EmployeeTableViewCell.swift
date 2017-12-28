//
//  EmployeeTableViewCell.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

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
    
    func setup(person: Person) {
        nameLbl.text = person.name
        roleLbl.text = person.role
        ageLbl.text = person.age.description
        salaryLbl.text = person.salary.description
        
        let skills = person.skills?.allObjects.first as? Skills
        
        creativityLbl.text = skills?.creative.description
        businessLbl.text = skills?.business.description
        technicalLbl.text = skills?.technical.description
    }
}
