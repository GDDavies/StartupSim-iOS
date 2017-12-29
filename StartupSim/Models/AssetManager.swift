//
//  AssetManager.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct AssetManager {
    static func createAsset(context: NSManagedObjectContext) {
        let asset = Asset(context: context)
    }
}
