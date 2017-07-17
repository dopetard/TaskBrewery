//
//  TaskViewController.swift
//  TaskBrewery
//
//  Created by Ankur Kumar on 15/07/17.
//  Copyright © 2017 Ankur Kumar. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    var tasks: [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task Brewery"
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //get the data from core data
        getData()
        
        //reload  the table view
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let task = tasks[indexPath.row]
        
        if task.isImportant{
            cell.textLabel?.text = "🍺\(task.name!)"
            
            
            
        } else {
            cell.textLabel?.text = task.name!
        }
        
        return cell
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch {
            
            print("Fetching failed")
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            print("delete at:\(indexPath)")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = self.tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                self.tasks = try context.fetch(Task.fetchRequest())
            }
            catch {
                print ("Fetching failed")
            }
            tableView.reloadData()
            
        }
        delete.backgroundColor = .red
        
        let more = UITableViewRowAction(style: .default, title: "Done") { (action:UITableViewRowAction, indexPath:IndexPath) in
            print("more at:\(indexPath)")
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = self.tasks[indexPath.row]
            
            if (task.isImportant){
                
                let alert = UIAlertController(title: "Share", message: "Horray! Buy yourself a 🍺 and Share on Twitter", preferredStyle: .actionSheet)
                
                let actionOne = UIAlertAction(title: "Share on Twitter", style: .default){(action) in
                    print ("Shared")}
                    
                    
                    
                    
                alert.addAction(actionOne)
                self.present(alert,animated: true, completion: nil)
            

            }
            
            else {
                context.delete(task)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                do {
                    self.tasks = try context.fetch(Task.fetchRequest())
                }
                catch {
                    print ("Fetching failed")
                }
                tableView.reloadData()
            }
        }
        more.backgroundColor = .orange
        
        return [delete, more]
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
