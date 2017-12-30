//
//  EmployeeTableViewCell.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData
import KDCircularProgress

struct EmployeeTableViewCellContent {
    var name: String?
    var role: String?
    var salary: Int32?
    
    var creativityLevel: Int16?
    var businessLevel: Int16?
    var technicalLevel: Int16?
    
    var expanded: Bool
    
    init(employee: Person) {
        self.name = employee.name
        self.role = employee.role
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
    @IBOutlet weak var salaryLbl: UILabel!
    
    @IBOutlet weak var creativityLbl: UILabel!
    @IBOutlet weak var businessLbl: UILabel!
    @IBOutlet weak var technicalLbl: UILabel!
    
    @IBOutlet weak var businessLevel: KDCircularProgress!
    @IBOutlet weak var creativityLevel: KDCircularProgress!
    @IBOutlet weak var technicalLevel: KDCircularProgress!
    
    let colours = [Colours.One, Colours.Two, Colours.Three]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
                
    }
    
    override func prepareForReuse() {
    }
    
    func setup(content: EmployeeTableViewCellContent) {
        nameLbl.text = content.name
        roleLbl.text = content.role
        salaryLbl.text = "£\(Strings.formatSalary(salary: content.salary!))"
        
        creativityLbl.text = content.creativityLevel?.description
        businessLbl.text = content.businessLevel?.description
        technicalLbl.text = content.technicalLevel?.description
        [businessLevel, creativityLevel, technicalLevel].enumerated().forEach{ setupProgressCircle(index: $0, progressView: $1) }
    }
    
    private func setupProgressCircle(index: Int, progressView: KDCircularProgress) {
        progressView.startAngle = -90
        progressView.progressThickness = 0.4
        progressView.trackColor = .lightGray
        progressView.clockwise = true
        progressView.roundedCorners = false
        progressView.set(colors: colours[index])
        
        progressView.animate(toAngle: 170, duration: 1.0, completion: nil)
    }
}
