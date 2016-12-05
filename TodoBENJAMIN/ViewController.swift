//
//  ViewController.swift
//  TodoBENJAMIN
//
//  Created by Benjamin Nussbaumer on 05/12/2016.
//  Copyright © 2016 Benjamin Nussbaumer. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource  {
   
    @IBOutlet weak var tableView: UITableView!
    
    //String array to store task
    var names = [NSManagedObject]()
    
    
    //Button add name because is the name of the task
    @IBAction func addName(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveTask(name: textField!.text!)
                                        self.tableView.reloadData()
                                        }
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
 
    //set a title and register the UITableViewCell class with the table view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            names = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    

    func saveTask(name: String){
    
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Task",
                                                 in:managedContext)
        
        let task = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
    
        task.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            
            names.append(task)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let task = names[indexPath.row] as! Task
        
        cell!.textLabel!.text = task.name
        
        return cell!
    }

}

