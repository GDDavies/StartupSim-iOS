//
//  ViewController.swift
//  StartupSim
//
//  Created by George Davies on 27/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

class HireEmployeeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //var ceo: NSManagedObject?
    @IBOutlet weak var tableView: UITableView!
    var personArray = [Person]()
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //save(name: "Bastian")
        
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeCellId")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        print(appDelegate?.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)
        managedContext = appDelegate?.persistentContainer.viewContext
        createShortlist()
    }
    
    private func createShortlist() {
        
        for _ in 0...2 {
            let person = PeopleMethods.createEmployee(role: .designer, context: managedContext!)
            personArray.append(person)
        }
    }
    
    func savePerson(person: Person) {
        
//        let entity = NSEntityDescription.entity(forEntityName: "CEO",
//                                                in: managedContext)!
//
//        let person = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
        
        //person.setValue(name, forKeyPath: "name")
        
        
        //managedContext.createCEO(context: managedContext)
        
        
        do {
            try managedContext?.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        //print(ceo.value(forKey: "name"))
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCellId", for: indexPath) as! EmployeeTableViewCell
        cell.setup(person: personArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<personArray.count where i != indexPath.row {
            managedContext?.delete(personArray[i])
        }
        savePerson(person: personArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }

}

