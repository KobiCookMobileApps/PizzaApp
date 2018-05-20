//
//  Preferences.swift
//  PizzaCreation
//
//  Created by Admin on 5/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation


class Preferences {
    
    struct Keys {
        static let pizzaCount = "pizzaCount"
    }
    
    //read pizza count from user defaults
    // if no count is present, use the default (20)
    static var pizzaCount: Int {
        let count = UserDefaults.standard.value(forKey: Keys.pizzaCount)
        
        return (count as? Int) ?? 20
    }
    
    //update the pizza count from saved user preferences
    class func setPizzaCount(to count: Int){
        UserDefaults.standard.set(count, forKey: Keys.pizzaCount)
        
    }
    
    
}
