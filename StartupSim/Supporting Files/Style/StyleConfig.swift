//
//  FontsConfig.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

protocol FontsConfig {
    static func NormalFnt(_ size:CGFloat) -> UIFont   // Standard font
    //static func FixScoreFnt(_ size:CGFloat)   -> UIFont   // Score numbers font
    //static func CntDownFnt(_ size:CGFloat)    -> UIFont   // Countdown font
    //static func SecondaryFnt(_ size:CGFloat)  -> UIFont   // Body (web, articles...) font
    static func BoldFnt(_ size:CGFloat) -> UIFont
}

protocol ColourConfig {
    static var One: UIColor { get } // Primary brand color
    static var Two: UIColor { get } // Secondary brand color
    static var TabBarHighlight: UIColor { get }
}
