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
    var employeeType: Role?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Colours.LightGrey
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeCellId")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        print(appDelegate?.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)
        managedContext = appDelegate?.persistentContainer.viewContext
        createShortlist()
    }
    
    private func createShortlist() {
        let expLevels = ["junior", "midLevel", "senior"]
        for i in 0...2 {
            for _ in 0...2 {
                let person = PeopleMethods.createEmployee(role: employeeType!, experience: expLevels[i], context: managedContext!)
                personArray.append(person)
            }
        }
    }
        
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        for i in 0..<personArray.count {
            managedContext?.delete(personArray[i])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCellId", for: indexPath) as! EmployeeTableViewCell
        cell.setup(person: personArray[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<personArray.count where i != indexPath.row {
            managedContext?.delete(personArray[i])
        }
        DatabaseManager.saveContext(context: managedContext!)
        self.dismiss(animated: true, completion: nil)
    }

}

