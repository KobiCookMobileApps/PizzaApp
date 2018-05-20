//
//  UIApplication+Delegate.swift
//  PizzaCreation
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    static var appDelegate: AppDelegate = {
        if Thread.isMainThread {
            return shared.delegate as! AppDelegate
        } else {
            var delegate: AppDelegate!
            DispatchQueue.main.sync {
                delegate = shared.delegate as! AppDelegate
            }
            return delegate
        }
    }()
    
}
