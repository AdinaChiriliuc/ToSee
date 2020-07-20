//
//  ViewController.swift
//  ToSee
//
//  Created by Adina Chiriliuc on 08/07/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToSeeViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toSeeItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
}
    override func viewWillAppear(_ animated: Bool) {

        title = selectedCategory!.name

        if let colourHex = selectedCategory?.colour {

            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller error")}

            if let navBarColour = UIColor(hexString: colourHex) {

            navBar.backgroundColor = UIColor(hexString: "#E0787C")
           // navBar.tintColor = ContrastColorOf(navBarColour , returnFlat: true)

            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]

            searchBar.backgroundColor = navBarColour
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toSeeItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 4
        
        if let item = toSeeItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = FlatWatermelonDark().darken(byPercentage:CGFloat(indexPath.row) / CGFloat(toSeeItems!.count)) {
            
                cell.backgroundColor = colour
           
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
        }
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items Added"
    }
        
       
        
        return cell
}
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toSeeItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add what you want to see", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Movie/TV Show"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
    
    
    func loadItems() {
        toSeeItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
               
               super.updateModel(at: indexPath)
                       
        if let item = self.toSeeItems?[indexPath.row] {
                    do {
                       try self.realm.write {
                       self.realm.delete(item)
                       }
                   } catch {
                           print("Error deleting items, \(error)")
           }
         }
       }
    
}


//MARK: - Search Bar Methods

extension ToSeeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toSeeItems = toSeeItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
       
    
}
