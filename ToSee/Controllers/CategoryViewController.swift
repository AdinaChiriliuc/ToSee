//
//  CategoryViewController.swift
//  ToSee
//
//  Created by Adina Chiriliuc on 13/07/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "#E0787C")
    }
    
    
//MARK: - TableView Datasource Methods
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 1
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 4
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        
        
        if let colour = FlatWatermelon().darken(byPercentage:CGFloat(indexPath.row) / CGFloat(categories!.count)) {

            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            
        }
        
    
                
        
        
        return cell
    }

        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToSeeViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
   
        
    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
          print("Error saving Category \(error)")
         }
               
       self.tableView.reloadData()
               
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
                        
        if let categoryForDeletion = self.categories?[indexPath.row] {
             do {
                try self.realm.write {
                self.realm.delete(categoryForDeletion)
                }
            } catch {
                    print("Error deleting category, \(error)")
    }
  }
}
   //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    
           var textField = UITextField()
           
           let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
           
           let action = UIAlertAction(title: "Add", style: .default) { (action) in
           
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            
            self.save(category: newCategory)
               
            
           }
        
           alert.addAction(action)
        
           alert.addTextField { (field) in
               textField = field
               textField.placeholder = "Add a new Category"
              
           }
           
           present(alert,animated: true, completion: nil)
    
    }
}
