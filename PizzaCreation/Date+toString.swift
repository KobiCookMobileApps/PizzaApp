//
//  Date+toString.swift
//  PizzaCreation
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

fileprivate struct Formatter{
    
    static var myFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return formatter
    }
}

extension Date {
    
    var toString: String {
        return Formatter.myFormatter.string(from: self)
    }
    
    init?(fromString: String) {
        let formatter = Formatter.myFormatter
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from: fromString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from: components)
        self = finalDate!
        
    }
}
