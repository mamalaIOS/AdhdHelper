//
//  ItemTableViewController.swift
//  adhdHelperRealmVerionAPP
//
//  Created by Amel Sbaihi on 1/21/23.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ItemTableViewController: SwipeTableViewController {
    
    var selectedCategory : Category!{
        
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    var itemsToDo : Results<Item>?
    
    let realm = try! Realm()
    
    //MARK: VIEWCONTROLLER LIFE CYCLE METHODS :
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        
       
        
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navbar1 = navigationController?.navigationBar else {fatalError("there is no nav bar ")}
        
        if let temporaryCategory = selectedCategory  {
            
            let colorString = temporaryCategory.colorString
            guard  let color = UIColor(hexString: colorString) else {fatalError("there is no fucking damn color ")}
            navbar1.backgroundColor = color
            navbar1.barTintColor = ContrastColorOf(color, returnFlat: true)
            title = temporaryCategory.name
            
            searchBar.barTintColor = color
            
            
        }
       
    }
    
    //MARK: DATA SOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDo?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemsToDo?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory.colorString)
                
            {
                guard  let fuckColor = color.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemsToDo!.count)) else {fatalError()}
                
                cell.backgroundColor = fuckColor
                
                cell.textLabel?.textColor = ContrastColorOf(fuckColor, returnFlat: true)
                
            }
        }
        else {
            
            cell.textLabel?.text = "no item to display "
           
                  }
        
        return cell
    }
    
    //MARK: DELEGATE METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = itemsToDo?[indexPath.row] {
            
            
            do {
                try realm.write {
                    
                    item.done = !item.done
                }
            }
            catch {
                
                print("error")
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true )
        tableView.reloadData()
        
        
    }
    
    
    
    
    //MARK: ADD ITEMS IBACTION Function
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add an item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
        
            //  here we appends the items to our itemsToDo
          
            guard let currentCategory = self.selectedCategory else {return}
            guard let textEntered =  textField.text else {return}
            
           
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textEntered
                    currentCategory.items.append(newItem)                }
                
            }
            
            catch {
                print("error saving data ")
            }
            
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { alertTextField  in
            alertTextField.placeholder = "enter an item here "
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
        
    }
    
    // now we need to perform the seague that will display this vc once a specific cell in category is clicked
    
    //MARK: METHODS FOR SAVING AND LOADING ITEMS USING REALM
    func loadItems () {
        
        itemsToDo = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true )
        tableView.reloadData()
        
    }
    
    override func updateModel (at indexPath : IndexPath) {
        
        guard let itemToDelete = self.itemsToDo?[indexPath.row] else {return}
        
        do {
            
            try self.realm.write{
                
                self.realm.delete(itemToDelete)
            }
            
        }
        
       catch {
            
           print("error deleting cell")
        }
    
    }
    
    
    //MARK: search functionalities extentions
    
    
    
    
}



extension ItemTableViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemsToDo = itemsToDo?.filter(" title CONTAINS[CD] %@ ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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
