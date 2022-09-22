//
//  ViewController.swift
//  ToDoApp
//
//  Created by Meriç Keskin on 20.09.2022.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var items = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDoCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = theTableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? ToDoTableViewCell {
            
            return cell
        }
        return UITableViewCell()
    }
}

