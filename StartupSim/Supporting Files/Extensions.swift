//
//  Extensions.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

extension Int32 {
    func round(_ value: Int32, toNearest: Int32) -> Int32 {
        return Int32(Darwin.round(Double(value) / Double(toNearest)) * Double(toNearest))
    }
}

//extension UINavigationController {
//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//}

