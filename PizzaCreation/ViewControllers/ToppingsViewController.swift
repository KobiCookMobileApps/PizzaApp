//
//  ToppingsViewController.swift
//  PizzaCreation
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ToppingsViewController: UIViewController {
    
    @IBOutlet weak var toppingsPickerView: UIPickerView!
    
    var toppings = ["Pepperoni", "Cheese", "Sausage", "Veggies", "Ham", "Pineapple", "Peppers", "Bacon", "Spinach", "Chicken"]
    
    var selectedToppings: [String] = []
    
    let cellIdentifier = "ToppingCell"
    
    let pizzaService = PizzaService()
    
    
    @IBOutlet weak var toppingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let savedToppings = UserDefaults.standard.string(forKey: "toppings") {
//            toppings = [savedToppings] + toppings
//        }
        
        
//        PizzaService.getToppings() { [unowned self] savedToppings in
//            self.toppings = self.toppings + savedToppings
//            DispatchQueue.main.async {
//                self.toppingsTableView.reloadData()
//            }
//        }
    
    }

    
    
    @IBAction func toppingAdded(_ sender: UIButton) {
        
        guard !toppings.isEmpty else {return}
        
        let row = toppingsPickerView.selectedRow(inComponent: 0)
        
        let selectedTopping = toppings[row]
        
        print ("Selected row \(selectedTopping)")
        toppings.remove(at: row)
        toppingsPickerView.reloadAllComponents()
        
        addTopping(selectedTopping)
        
    }
    
    func addTopping(_ topping: String) {
        
        //add to array of selected toppings
        selectedToppings.append(topping)
        
        // get index path of nrw row
        let ip = IndexPath(row: selectedToppings.count-1, section: 0)
        
        //update table view
        toppingsTableView.insertRows(at: [ip], with: .automatic)
        
    }
    
    @IBAction func pizzaOrdered(_ sender: UIButton) {
        
        PizzaService.saveOrder(toppings: selectedToppings)
        
        toppings = (toppings + selectedToppings).sorted()
        selectedToppings.removeAll()
        
        toppingsPickerView.reloadAllComponents()
        toppingsTableView.reloadData()
    }
    
    @IBAction func extraTopping(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Custom Topping", message: "Add your favorite topping", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let toppingToSave = textField.text else {
                return
            }
            
//            UserDefaults.standard.set(toppingToSave, forKey: "toppings")
            PizzaService.saveTopping(toppings: [toppingToSave])
            self.toppings.insert(toppingToSave, at: 0)
            self.toppingsPickerView.reloadAllComponents()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    

}


extension ToppingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toppings.count
    }
}

extension ToppingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toppings[row]
    }
}



extension ToppingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedToppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = selectedToppings[indexPath.row]
        
        return cell
    }
}

extension ToppingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let removedTopping = selectedToppings.remove(at: indexPath.row)
        
        //update Table View
        toppingsTableView.deleteRows(at: [indexPath], with: .automatic)
        
        toppings.append(removedTopping)
        
        toppingsPickerView.reloadAllComponents()
        
    }
}
