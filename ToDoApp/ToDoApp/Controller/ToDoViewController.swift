//
//  ViewController.swift
//  ToDoApp
//
//  Created by Meriç Keskin on 20.09.2022.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var items = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDoCell")
    }

    @IBAction func addBtnClick(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = theTableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? ToDoTableViewCell {
            let item = items[indexPath.row]
            cell.nameLbl.text = item.name
            let dateFormatter = DateFormatter()
            let dateStr = dateFormatter.string(from: item.lastEditDate ?? Date())
            cell.dateLbl.text = .getFormattedDate(string: dateStr, formatter: "MMM d")
            cell.timeLbl.text = .getFormattedDate(string: dateStr, formatter: "HH:mm")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getItems() {
        do {
            items = try context?.fetch(ToDoItem.fetchRequest()) ?? []
            DispatchQueue.main.async {
                self.theTableView.reloadData()
            }
        } catch let e {
            print(e)
        }
    }
    
    func createItem(name: String) {
        if let context = context ?? self.context {
            let newItem = ToDoItem(context: context)
            newItem.name = name
            newItem.lastEditDate = Date()
        }
        do {
            try context?.save()
            getItems()
        } catch let e {
            print(e)
        }
    }
    
    func updateItem(item: ToDoItem, newName: String) {
        item.name = newName
        item.lastEditDate = Date()
        do {
            try context?.save()
            getItems()
        } catch let e {
            print(e)
        }
    }
    
    func deleteItem(item: ToDoItem) {
        context?.delete(item)
        do {
            try context?.save()
            getItems()
        } catch let e {
            print(e)
        }
    }
}
