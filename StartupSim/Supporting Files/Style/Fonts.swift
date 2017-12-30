//
//  Fonts.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

struct Fonts: FontsConfig {
    static func NormalFnt(_ size: CGFloat) -> UIFont { return UIFont(name: "Montserrat-Regular", size: size)! }
    static func BoldFnt(_ size: CGFloat) -> UIFont { return UIFont(name: "Montserrat-Bold", size: size)! }
}

struct Strings {
    static func formatSalary(salary: Int32) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        // TODO Add localised curreny prefix
        return numberFormatter.string(from: NSNumber(value: salary))!
    }
}
