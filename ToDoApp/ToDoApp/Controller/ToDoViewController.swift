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
        
        getItems()
    }

    @IBAction func addBtnClick(_ sender: Any) {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Enter", style: .cancel) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self?.createItem(name: text)
        })
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = theTableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? ToDoTableViewCell {
            let item = items[indexPath.row]
            cell.nameLbl.text = item.name
            cell.dateLbl.text = .getFormattedDate(string: (item.lastEditDate ?? Date()).description, formatter: "MMM d")
            cell.timeLbl.text = .getFormattedDate(string: (item.lastEditDate ?? Date()).description, formatter: "HH:mm")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        theTableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit the item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Enter", style: .cancel) { [weak self] _ in
                guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
                self?.updateItem(item: item, newName: text)
            })
            self?.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true)
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
