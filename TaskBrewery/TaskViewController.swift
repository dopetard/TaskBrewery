//
//  TaskViewController.swift
//  TaskBrewery
//
//  Created by Ankur Kumar on 15/07/17.
//  Copyright © 2017 Ankur Kumar. All rights reserved.
//


import UIKit
import TwitterKit



class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var beer: Int = 0
    var tasks: [Task] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        self.title = "Task Brewery"
        tableView.dataSource = self
        tableView.delegate = self
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        addItemView.layer.cornerRadius = 5
        
        
        // Do any additional setup after loading the view.
    }
    
final class alertController : UIAlertController {
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
    

    
    func animateIn() {
        
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut(){
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (sucess: Bool ) in
            
            self.addItemView.removeFromSuperview()
        }
        
    }
    
    
    @IBAction func ClearBeer(_ sender: Any) {
        
        numberOfBeer.text = String("No Beer 😔")
        
    }
    
    @IBOutlet weak var numberOfBeer: UILabel!
    
    
    
    @IBAction func ShowBeer(_ sender: Any) {
        
        animateIn()
        numberOfBeer.text = String.init(describing: beer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false

        
        
        //get the data from core data
        getData()
        
        //reload  the table view
        tableView.reloadData()
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Log out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            
            
            let store = Twitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
                print ("logged out")
                
                
                self.navigationController?.popToRootViewController(animated: true) }

            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var addItemView: UIView!
    var effect:UIVisualEffect!
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        
        animateOut()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        

        
        cell.textLabel?.font = UIFont(name:"AvenirNextCondensed-regular", size: 16)
        
        let task = tasks[indexPath.row]
        
        if task.isImportant{
            cell.textLabel?.text = "🍺   \(task.name!)"
            
        } else {
            cell.textLabel?.text = "  \(task.name!)"
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
                    self.beer = self.beer + 1
                    context.delete(task)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        do {
                            self.tasks = try context.fetch(Task.fetchRequest())
                        }
                        catch {
                            print ("Fetching failed")
                        }
                        tableView.reloadData()
                    let composer = TWTRComposer()
                    
                    composer.setText("I just earned right to buy myself a 🍺 by nailing a task at TaskBrewery")
                    composer.setImage(UIImage(named: "twitterkit"))
                    
                    // Called from a UIViewController
                    composer.show(from: self.navigationController!) { (result) in
                        if (result == .done) {
                            print("Successfully composed Tweet")
                            
                        } else {
                            print("Cancelled composing") } }

                
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
        
        return [delete, more, ]
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
