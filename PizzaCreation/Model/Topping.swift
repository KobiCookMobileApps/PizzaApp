//
//  Topping.swift
//  PizzaCreation
//
//  Created by Admin on 5/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Firebase


struct Toppings {
    
    var toppings: String
    
    
    init?(snapshot: Any?) {
        guard let data = snapshot as? DataSnapshot, let value = data.value as? [String: AnyObject],
            let toppings = value["toppings"] as? String else {
                return nil
        }
        
        self.toppings = toppings
    }
    
    init(toppings: String) {
        self.toppings = toppings
    }
    
    
    
    
}
