//
//  ExpandedCellBodyView.swift
//  StartupSim
//
//  Created by George Davies on 29/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class ExpandedCellBodyView: UIView {

    @IBOutlet weak var testLbl1: UILabel!
    @IBOutlet weak var testLbl2: UILabel!
    
    @IBOutlet weak var testView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.testLbl1.alpha = 0
        self.testLbl2.alpha = 0
        self.testView.alpha = 0
    }
    
    func setup(content: EmployeeTableViewCellContent) {
        
    }

    func changeBody(hide: Bool) {
        UIView.animate(withDuration: 0.1, delay: hide ? 0.0 : 0.1, options: [.curveEaseIn], animations: {
            self.testLbl1.alpha = hide ? 0 : 1
            self.testLbl2.alpha = hide ? 0 : 1
            self.testView.alpha = hide ? 0 : 1
        }, completion: nil)
    }
}
