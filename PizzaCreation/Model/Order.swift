//
//  Order.swift
//  PizzaCreation
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import CoreData
import Firebase


struct Order {
    
    let ref: DatabaseReference?
    let key: String
    let toppings: [String]
    let date: Date
    var favorite: Bool
    
    var toppingString: String {
        return toppings.joined(separator: ", ")
    }
    
    var asAnyObject: Any {
        return ["toppings": toppings, "favorite": favorite, "date": date.toString]
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let toppings = value["toppings"] as? [String],
            let date = value["date"] as? String,
            let favorite = value["favorite"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.toppings = toppings
        self.date = Date(fromString: date) ?? Date()
        self.favorite = favorite
    }
    
    init(toppings: [String]) {
        self.toppings = toppings
        self.date = Date()
        self.favorite = false
        self.key = ""
        self.ref = nil
    }
    
//    init?(entity: NSManagedObject) {
//        guard let date = entity.value(forKey: Entity.Keys.Pizza.date.rawValue) as? Date,
//            let favorite = entity.value(forKey: Entity.Keys.Pizza.favorite.rawValue) as? Bool,
//            let toppings = entity.value(forKey: Entity.Keys.Pizza.toppings.rawValue) as? [String] else {
//                return nil
//        }
//       self.date = date
//        self.favorite = favorite
//        self.toppings = toppings
//    }
}



