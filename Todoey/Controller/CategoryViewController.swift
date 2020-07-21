//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 夏英浩 on 7/20/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        let newCategory = Category(context: context)
        newCategory.name = "IOS Developer"
        categories.append(newCategory)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name
 
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when press add item
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!

            self.categories.append(newCategory)
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

        //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
        //MARK: - Data Manipulation Methods
    func saveCategories() {
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    

}
