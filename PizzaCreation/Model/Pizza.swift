//
//  Pizza.swift
//  PizzaCreation
//
//  Created by Admin on 5/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Firebase


struct Pizza: Decodable {
    
    var toppings: [String]
    var price: Int?
    var timesOrdered: Int?
    
    var asAnyObject: Any {
        return ["toppings": toppings, "price": price!]
    }
    
    
    init?(snapshot: Any?) {
        guard let data = snapshot as? DataSnapshot, let value = data.value as? [String: AnyObject],
        let timesOrdered = value["timesOrdered"] as? Int,
            let toppings = value["toppings"] as? [String], let price = value["price"] as? Int else {
                return nil
        }
        
 
        self.toppings = toppings
        self.price = price
        self.timesOrdered = timesOrdered
    }
    
    init(toppings: [String], price: Int?) {
        self.toppings = toppings
        self.price = price

    }
    
}


extension Pizza: Equatable {
    
    static func ==(lhs: Pizza, rhs: Pizza) -> Bool {
        return lhs.toppings.sorted() == rhs.toppings.sorted()
    }
}

extension Pizza: Hashable {
    
    var hashValue: Int {
        return toppings.sorted().joined().hashValue
    }
}

