//
//  Entity.swift
//  PizzaCreation
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation


struct Entity {
    
    struct Keys {
        enum Pizza: String {
            case favorite = "favorite"
            case date = "orderDate"
            case toppings = "toppings"
        }
    }
    
    enum Names: String {
        case pizza = "PizzaOrder"
    }
}
