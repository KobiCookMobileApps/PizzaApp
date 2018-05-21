//
//  PizzaService.swift
//  PizzaCreation
//
//  Created by Admin on 5/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase


typealias PizzaHandler = ([(Pizza, Int)]) -> Void
typealias OrderHandler = ([Order]) -> Void
typealias ToppingsHandler = ([String]) -> Void


class PizzaService {
    
    
    
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
            case order = "order"
            case toppings = "toppings"
        }
    }
    
    static let pizzaRef = Database.database().reference(withPath: Entity.Names.pizza.rawValue)
    static let orderRef = Database.database().reference(withPath: Entity.Names.order.rawValue)
    static let toppingsRef = Database.database().reference(withPath: Entity.Names.toppings.rawValue)
    
    
    
    
//    static var persistentContainer: NSPersistentContainer = {
//
//        var delegate: AppDelegate!
//        DispatchQueue.main.sync {
//            delegate = UIApplication.shared.delegate as! AppDelegate
//        }
//        return delegate.persistentContainer
//    }()
    
    
    private class func uploader(array: [Pizza:Int]) {
        
        for array in array {
            
            let pizza: Any? = ["toppings": array.key.toppings,
                               "price": array.key.price ?? 0,
                               "timesOrdered": array.value]
            let reference = PizzaService.pizzaRef.child(array.key.toppings.joined(separator: ", "))
            reference.setValue(pizza)
        }
        
    }
    
    private class func uploadJsonToFirebase(completion: @escaping PizzaHandler) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let path = Bundle.main.path(forResource: "pizzas", ofType: "json") else {
                return }
            
            let fileURL = URL(fileURLWithPath: path)
            
            do {
                let data = try  Data(contentsOf: fileURL)
                
                let pizzas = try JSONDecoder().decode([Pizza].self, from: data)
                
                let counts = pizzas.reduce(into: [Pizza: Int]()){ $0[$1, default: 0] += 1}
                
                uploader(array: counts)
                
                let topPizzas = counts.sorted(by: {$0.value > $1.value})
                
                completion(topPizzas)
                
            } catch {
                print (error.localizedDescription)
            }
        }
        
    }
    
    
    
    class func getPizzas(limit: Int = 20, completion: @escaping PizzaHandler) {
        
        
        PizzaService.pizzaRef.observe(.value) { (snapshot) in
            
            var pizzaOrders = [Pizza:Int]()
            
            for data in snapshot.children {
                let dataSnap: DataSnapshot = data as! DataSnapshot
                let pizza = Pizza(snapshot: dataSnap)
                pizzaOrders[pizza!] = pizza?.timesOrdered
            }
            
            
            var topPizzas = [(Pizza, Int)]()
            
            topPizzas = pizzaOrders.sorted(by: {$0.value > $1.value})
        
            let end = min(limit, topPizzas.count)
            
            completion(Array(topPizzas[0..<end]))
            
        }
    }
    
    
    
    
    // DONE
    
    class func updateOrder(_ order: Order) {
        
        let orderReference = PizzaService.orderRef.child(order.toppingString)
        orderReference.setValue(order.toppingString)
        
//        DispatchQueue.global(qos: .utility).async {
//            let context = persistentContainer.newBackgroundContext()
//
//            // create request for orders
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Entity.Names.pizza.rawValue)
//
//            // grab the specific order
//            let key = Entity.Keys.Pizza.date.rawValue
//            let fetchPredicate = NSPredicate(format: "\(key)=%@", argumentArray: [order.date])
//
//            // apply the predicate
//            fetchRequest.predicate = fetchPredicate
//
//            var results: [Any]!
//
//
//            do {
//                results = try context.fetch(fetchRequest)
//                //                orders = (results as? [Order] ?? [])
//            } catch {
//                return
//            }
//
//            guard let orders = results as? [NSManagedObject], let storedOrder = orders.first else {
//                return
//            }
//            // update properties
//            storedOrder.setValue(order.toppings, forKey: Entity.Keys.Pizza.toppings.rawValue)
//            storedOrder.setValue(order.favorite, forKey: Entity.Keys.Pizza.favorite.rawValue)
//
//            do {
//                try context.save()
//            } catch {
//                print ("error")
//            }
//        }
    }
    
    // DONE
    
    class func deleteOrder(order: Order) {
        
        let orderReference = PizzaService.orderRef.child(order.toppingString)
        orderReference.removeValue()
        
//        DispatchQueue.global().async {
//
//            let context = persistentContainer.newBackgroundContext()
//
//            // create request for orders
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Entity.Names.pizza.rawValue)
//
//            // grab the specific order
//            let key = Entity.Keys.Pizza.date.rawValue
//            let fetchPredicate = NSPredicate(format: "\(key)=%@", argumentArray: [order.date])
//
//            // apply the predicate
//            fetchRequest.predicate = fetchPredicate
//
//            var results: [Any]!
//
//
//            do {
//                results = try context.fetch(fetchRequest)
//            } catch {
//                return
//            }
//
//            guard let orders = results as? [NSManagedObject], let storedOrder = orders.first else {
//                return
//            }
//
//            context.delete(storedOrder)
//
//            do {
//                try context.save()
//                print ("deletion saved")
//            } catch {
//                print ("could not save deletion")
//            }
//        }

    }
    
    
    // DONE
    
    class func saveTopping(toppings: [String]) {
        
        PizzaService.toppingsRef.setValue(toppings)
    
    }
    
    class func saveOrder(toppings: [String]) {
        
        let newOrder = Order(toppings: toppings)
        let orderRef = PizzaService.orderRef.child(newOrder.toppings.joined(separator: ", "))
        orderRef.setValue(newOrder.asAnyObject)
    
    
//        DispatchQueue.global().async {
//            let context = persistentContainer.newBackgroundContext()
//            
//            guard let entity = NSEntityDescription.entity(forEntityName: Entity.Names.pizza.rawValue, in: context) else {
//                print ("Invalid entity name")
//                return
//            }
//            
//            let order = NSManagedObject(entity: entity, insertInto: context)
//            
//            
//            order.setValue(false, forKey: Entity.Keys.Pizza.favorite.rawValue)
//            order.setValue(Date(), forKey: Entity.Keys.Pizza.date.rawValue)
//            order.setValue(toppings, forKey: Entity.Keys.Pizza.toppings.rawValue)
//            
//            do {
//                try context.save()
//                
//                NotificationCenter.default.post(name: .orderCreated, object: nil)
//                
//                print ("order saved")
//            } catch {
//                print ("Could not save")
//            }
//            
//        }
    }
    
    
    
    class func getOrders(completion: @escaping OrderHandler) {
        
        PizzaService.orderRef.observe(.value) { (snapshot) in
            var allOrders = [Order]()
            for snapshot in snapshot.children {
                let data: DataSnapshot = snapshot as! DataSnapshot
                let order = Order(snapshot: data)
                allOrders.append(order!)
            }
            completion(allOrders)
            print("received orders")
        }
        

        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let context = persistentContainer.newBackgroundContext()
//
//            /// create request for orders
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Entity.Names.pizza.rawValue)
//
//            // sort by date
//            let sortDescriptors = [NSSortDescriptor(key: Entity.Keys.Pizza.date.rawValue, ascending: true)]
//
//            // apply sorting to request
//            fetchRequest.sortDescriptors = sortDescriptors
//
//            var results: [Any]!
//
//
//            do {
//                results = try context.fetch(fetchRequest)
////                orders = (results as? [Order] ?? [])
//            } catch {
//                completion([])
//                return
//            }
//
//            let orders = (results as? [NSManagedObject] ?? [])
//            let allOrders = orders.compactMap { Order(entity: $0 ) }
//            completion(allOrders)
//        }
    }
    
    class func getToppings(completion: @escaping ToppingsHandler) {

        PizzaService.toppingsRef.observe(.value) { (snapshot) in
            let toppings = snapshot.value as? [String]
            completion(toppings!)
            print ("fetched firebase toppings")


        }

    }
}
