//
//  SwipeTableViewController.swift
//  ToSee
//
//  Created by Adina Chiriliuc on 16/07/2020.
//  Copyright © 2020 Adina Chiriliuc. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
               
            cell.delegate = self
             
               
               return cell
           }
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
             
            self.updateModel(at: indexPath)

        }
            
            deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
        }
        
        func tableView(_ collectionView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
        }
        
    func updateModel(at indexPath: IndexPath) {
        
    }
}
