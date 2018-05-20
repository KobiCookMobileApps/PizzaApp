//
//  SettingsViewController.swift
//  PizzaCreation
//
//  Created by Admin on 5/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol settingsDelegate: class {
    func updatedPizzaCount(to count: Int)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    
    weak var delegate: settingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel.text = String(Preferences.pizzaCount)
        slider.value = Float(Preferences.pizzaCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let value = Int(slider.value)
        print(value)
        
        numberLabel.text = String(value)
    }
    
    
    @IBAction func savedChanges(_ sender: UIButton) {
        
        let value = Int(slider.value)
        
        // save the user preferences
        Preferences.setPizzaCount(to: value)
        
        // call the delegate function
        delegate?.updatedPizzaCount(to: value)
        
        // go back to previous screen
        navigationController?.popViewController(animated: true)
    }
    
    


}
