//
//  AddTaskViewController.swift
//  TaskBrewery
//
//  Created by Ankur Kumar on 15/07/17.
//  Copyright © 2017 Ankur Kumar. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var textFeild: UITextField!
    
    @IBOutlet weak var isImp: UISwitch!

    @IBAction func datePickerDidSelectNewDate(_ sender: UIDatePicker) {
        
        let selectedDate = sender.date
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate!).persistentContainer.viewContext
        let task = Task(context: context)
        task.name = textFeild.text!
        task.isImportant = isImp.isOn
        
        //Save the data to core data
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        navigationController!.popViewController(animated: true)
        
    }
    

    }

    
