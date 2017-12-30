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
    
    func setup(person: Person) {
        nameLbl.text = person.name
        roleLbl.text = person.role
        salaryLbl.text = "£\(Strings.formatSalary(salary: person.salary))"
        
        let skills = person.skills?.allObjects.first as? Skills
        
        creativityLbl.text = skills?.creative.description
        businessLbl.text = skills?.business.description
        technicalLbl.text = skills?.technical.description
        
        let new = zip([businessLevel, creativityLevel, technicalLevel], [skills?.creative, skills?.business, skills?.technical])
        
        _ = new.enumerated().map {
            setupProgressCircle(index: $0.offset, progressView: $0.element.0!, level: $0.element.1!)
        }
    }
    
    private func setupProgressCircle(index: Int, progressView: KDCircularProgress, level: Int16) {
        
        let ratio = Double(level) / 20
        //progressView.angle = 0
        progressView.startAngle = 270
        progressView.progressThickness = 0.4
        progressView.trackColor = .lightGray
        progressView.clockwise = true
        progressView.roundedCorners = false
        progressView.set(colors: colours[index])
        progressView.animate(toAngle: ratio * 360, duration: 0.5, completion: nil)
    }
}
