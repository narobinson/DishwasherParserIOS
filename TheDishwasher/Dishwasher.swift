//
//  Dishwasher.swift
//  TheDishwasher
//
//  Created by Admin on 7/29/18.
//  Copyright © 2018 narobinson. All rights reserved.
//


import Foundation
import CoreData

struct DishwasherResponse: Decodable {
    let products: [Dishwasher]
}

struct Dishwasher: Decodable {
    
    let title: String
    let price: [String: String]
    let image: String
    let brand: String
    
    lazy var imageURL: URL? = {
        // if statement checks if there's "https:", if not, then add it, if so, then leave be
        if image.prefix(6) != "https:" {
            return URL(string: "https:" + image)
        }
        return URL(string: image)
    }()
    
    var currentPrice: Double? {
        return Double(price["now"] ?? "")
    }
    
    init?(from obj: NSManagedObject){
        
        guard
            let name = obj.value(forKey: "name") as? String,
            let price = obj.value(forKey: "price") as? Double,
            let image = obj.value(forKey: "image") as? String,
            let brand = obj.value(forKey: "washerBrand") as? NSManagedObject, 
            let brandName = brand.value(forKey: "name") as? String else {
                return nil
        }
        
        self.title = name
        self.price = ["now": String(price)]
        self.image = image
        self.brand = brandName
    }
}
