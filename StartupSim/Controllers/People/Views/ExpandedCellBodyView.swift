//
//  ExpandedCellBodyView.swift
//  StartupSim
//
//  Created by George Davies on 29/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import LinearProgressBar

class ExpandedCellBodyView: UIView {

    @IBOutlet weak var statsContainerView: UIView!
    
    @IBOutlet weak var businessLbl: UILabel!
    @IBOutlet weak var businessProgressView: LinearProgressBar!
    @IBOutlet weak var businessProgressLbl: UILabel!
    
    @IBOutlet weak var creativityLbl: UILabel!
    @IBOutlet weak var creativityProgressView: LinearProgressBar!
    @IBOutlet weak var creativeProgressLbl: UILabel!
    
    @IBOutlet weak var technicalLbl: UILabel!
    @IBOutlet weak var technicalProgressView: LinearProgressBar!
    @IBOutlet weak var technicalProgressLbl: UILabel!

    @IBOutlet weak var salaryContainerView: UIView!
    @IBOutlet weak var salaryLbl: UILabel!
    
    @IBOutlet weak var happinessLbl: UILabel!
    @IBOutlet weak var happinessIcon: UIImageView!
    
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var disciplineBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var fireBtn: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statsContainerView.backgroundColor = Colours.DarkGrey
        
        self.backgroundColor = Colours.ThemePrimary.withAlphaComponent(0.15) //Colours.LightGrey
        businessProgressView.barColor = Colours.One
        businessProgressView.trackColor = .white
        businessProgressView.trackPadding = 0
        
        creativityProgressView.barColor = Colours.Two
        creativityProgressView.trackColor = .white
        creativityProgressView.trackPadding = 0
        
        technicalProgressView.barColor = Colours.Three
        technicalProgressView.trackColor = .white
        technicalProgressView.trackPadding = 0
        
        salaryLbl.layer.masksToBounds = true
        salaryLbl.layer.cornerRadius = 5

        [fireBtn, rewardBtn, upgradeBtn, disciplineBtn].forEach{
            $0?.addShadow()
        }
        
        [statsContainerView,
         businessLbl, businessProgressView,
         creativityLbl, creativityProgressView,
         technicalLbl, technicalProgressView,
         salaryContainerView, salaryLbl,
         happinessLbl, happinessIcon,
         rewardBtn, disciplineBtn, upgradeBtn, fireBtn].forEach{ element in
            element.alpha = 0
        }
    }
    
    func setup(person: Person) {//content: EmployeeTableViewCellContent) {
        
        let skills = person.skills?.allObjects.first as? Skills
        
        businessProgressView.progressValue = CGFloat(skills!.businessProgress)
        businessProgressLbl.text = skills!.businessProgress.description
        creativityProgressView.progressValue = CGFloat(skills!.creativeProgress)
        creativeProgressLbl.text = skills!.creativeProgress.description
        technicalProgressView.progressValue = CGFloat(skills!.technicalProgress)
        technicalProgressLbl.text = skills!.technicalProgress.description
        
        let formattedSalary = Strings.formatSalary(salary: person.salary)
        salaryLbl.text = "Salary £\(formattedSalary)"
        
        happinessIcon.image = returnEmoji(happiness: person.happiness)
        happinessLbl.text = "\(String(format: "%.f", person.happiness))%"
        
    }

    private func returnEmoji(happiness: Double) -> UIImage {
        switch happiness {
        case 0..<20:
            return UIImage(named: "emoji5")!
        case 20..<40:
            return UIImage(named: "emoji4")!
        case 40..<60:
            return UIImage(named: "emoji3")!
        case 60..<80:
            return UIImage(named: "emoji2")!
        case 80..<100:
            return UIImage(named: "emoji1")!
        default:
            return UIImage(named: "emoji3")!
        }
    }
    
    func changeBody(hide: Bool) {
        UIView.animate(withDuration: 0.1, delay: hide ? 0 : 0.2, options: [.curveLinear], animations: {
            
            [self.statsContainerView,
             self.businessLbl, self.businessProgressView,
             self.creativityLbl, self.creativityProgressView,
             self.technicalLbl, self.technicalProgressView,
             self.salaryContainerView, self.salaryLbl,
             self.happinessLbl, self.happinessIcon,
             self.rewardBtn, self.disciplineBtn, self.upgradeBtn, self.fireBtn].forEach{ element in
                element.alpha = hide ? 0 : 1
            }
        }, completion: nil)
    }
}
