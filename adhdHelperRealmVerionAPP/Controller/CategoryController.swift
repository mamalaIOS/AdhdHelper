//
//  ViewController.swift
//  adhdHelperRealmVerionAPP
//
//  Created by Amel Sbaihi on 1/19/23.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryController : SwipeTableViewController{
    
    
    
   
    
   var categories : Results<Category>!
    
   var  realm = try! Realm()
    
    //MARK: View Controller Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = " Category"
        tableView.rowHeight = 80
        loadCategory()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("there is no navigation controller ")}
        
    }

//MARK: Data Source Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? " no category added here "
        
        if let color1 = UIColor(hexString: categories[indexPath.row].colorString) {
            
            cell.backgroundColor = color1
            cell.textLabel?.textColor = ContrastColorOf(color1, returnFlat: true)
        }
        return cell
    }
    
    //MARK: delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.segueId, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        
        let destinationVc = segue.destination as! ItemTableViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        
        if let indexPath = indexPath {
            
            destinationVc.selectedCategory = categories?[indexPath.row]
        }
        
        
        
    }
    
    //MARK: add button on the navigation controller
    
    
    @IBAction func barButtonItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: " new category ", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add a category ", style: .default) { action in
            
            
            let newCategory = Category()
            
            
            guard let text = textField.text else {return}
            
            newCategory.name = text
            newCategory.colorString = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newCategory)
            
            self.tableView.reloadData()
            
           
            
            
            
        }
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "enter a new category here"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true )
        
}
    
    
    
    
    
    func saveCategories (category : Category) {
        
        do {
            try realm.write {
                
                realm.add(category)
            }
        }
        catch {print("error saving data ")}
        
    }
    
    
    
    func loadCategory () {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
    override func updateModel (at indexPath : IndexPath) {
        
        guard let categoryToDelete = self.categories?[indexPath.row] else {return}
        
        do {
            
            try self.realm.write{
                
                self.realm.delete(categoryToDelete)
            }
            
        }
        
       catch {
            
           print("error deleting cell")
        }
    
    }
    
    
}

//MARK: UIsearchBar Extension

extension CategoryController : UISearchBarDelegate  {
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // guard let textUnwrapped = searchBar.text  else {return}
        
        categories = categories?.filter(" name CONTAINS[CD] %@ ", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadCategory()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
   
   
    
    



