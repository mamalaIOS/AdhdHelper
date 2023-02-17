//
//  SwipeTableViewController.swift
//  adhdHelperRealmVerionAPP
//
//  Created by Amel Sbaihi on 1/22/23.
//

import UIKit
import SwipeCellKit      

class SwipeTableViewController: UITableViewController , SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath) as! SwipeTableViewCell
        
        cell.delegate =  self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
        }

        
        // customize the action appearance
        
        
        
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }

    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
       
        return options
    }
    
    
    
    func updateModel (at indexPath : IndexPath )  {     }
    
}
