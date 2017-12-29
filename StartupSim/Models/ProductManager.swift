//
//  ProductsManager.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

struct ProductManager {
    static func createProduct(product: Product, context: NSManagedObjectContext) {
        let newProduct = Product(context: context)
        newProduct.name = product.name
        newProduct.developmentCost = product.developmentCost
        newProduct.defects = calculateDefects(product)
        newProduct.nicheLevel = calculateNicheLevel(product)
        newProduct.type = product.type
        newProduct.rrp = product.rrp
        newProduct.warrantyMonths = product.warrantyMonths
    }
    
    static func calculateDefects(_ product: Product) -> Int16 {
        return 0
    }
    
    static func calculateNicheLevel(_ product: Product) -> Double {
        return 0
    }
}

enum ProductType: String {
    case software = "software"
    case hardware = "hardware"
}
