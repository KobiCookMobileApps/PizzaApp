//
//  ViewController.swift
//  PizzaCreation
//
//  Created by Admin on 5/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TopPizzasViewController: UIViewController {
    
    @IBOutlet weak var pizzaTableView: UITableView!
    
    var pizzas = [(Pizza, Int)]()
    let cellIdentifier = "PizzaCell"
    var filteredPizzas = [(Pizza, Int)]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pizzaTableView.dataSource = self
        
        fetchPizzas(count: Preferences.pizzaCount)
        
        title = "Top Pizzas"
        
        createSearchBar()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SettingsViewController else {
            return
        }
        vc.delegate = self
    }
    
    
    
    @IBAction func sortPizza(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let ascending = UIAlertAction(title: "Pizza Ascending", style: .default) { [unowned self] action in
            
            let ascendingPizza = self.pizzas.sorted(by: {$0.1 > $1.1})
            
            self.pizzas = ascendingPizza

            self.pizzaTableView.reloadData()
        }
        
        let descending = UIAlertAction(title: "Pizza Descending", style: .default) { [unowned self] action in
            
            let descendingPizza = self.pizzas.sorted(by: {$0.1 < $1.1})
            
            self.pizzas = descendingPizza
            
            self.pizzaTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ascending)
        alert.addAction(descending)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func fetchPizzas(count: Int) {
        PizzaService.getPizzas(limit: count) { [unowned self] pizzas in
            self.pizzas = pizzas
            
            DispatchQueue.main.async {
                self.pizzaTableView.reloadData()
            }
        }
    }
    
    
    
    func createSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pizzas"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPizzas = pizzas.filter({ (pizza: (Pizza, Int)) -> Bool in
            return pizza.0.toppings.joined(separator: ", ").lowercased().contains(searchText.lowercased())
        })
        
        pizzaTableView.reloadData()
    }
    
}


extension TopPizzasViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredPizzas.count
        }
        
            return pizzas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let pizza: (Pizza, Int)
        
        if isFiltering() {
            
            pizza = filteredPizzas[indexPath.row]
        } else {
            
            pizza = pizzas[indexPath.row]
        }
        
        cell.textLabel?.text = pizza.0.toppings.joined(separator: ", ")
        cell.detailTextLabel?.text = String(pizza.1)
        
        return cell
    }
}


extension TopPizzasViewController: settingsDelegate {
    func updatedPizzaCount(to count: Int) {
        fetchPizzas(count: count)
    }
}

extension TopPizzasViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

