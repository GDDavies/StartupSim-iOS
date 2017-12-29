//
//  ViewEmployeesVC.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

class ViewEmployeesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    var cellContent = [EmployeeTableViewCellContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeCellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
            cellContent.removeAll()
            for person in people {
                let employee = EmployeeTableViewCellContent(employee: person as! Person)
                cellContent.append(employee)
            }
            
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func hireEmployeePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowPotentialHires", sender: self)
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCellId", for: indexPath) as! EmployeeTableViewCell
        cell.setup(content: cellContent[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellContent[indexPath.item].expanded ? 200 : 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellContent[indexPath.row].expanded = !cellContent[indexPath.item].expanded
        setCellBody(indexPath, remove: !cellContent[indexPath.row].expanded)
    }
    
    private func setCellBody(_ indexPath: IndexPath, remove: Bool) {
        let cell = tableView.cellForRow(at: indexPath) as! EmployeeTableViewCell
        if remove {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                cell.viewWithTag(indexPath.row + 1)?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + 100, width: cell.bounds.width, height: 0)
                (cell.viewWithTag(indexPath.row + 1) as? ExpandedCellBodyView)?.changeBody(hide: true)
            }, completion: { _ in
                cell.viewWithTag(indexPath.row + 1)?.removeFromSuperview()
            })
        } else {
            let bodyView = UINib(nibName: "ExpandedCellBodyView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ExpandedCellBodyView
            bodyView?.tag = indexPath.row + 1
            bodyView?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + 100, width: cell.bounds.width, height: 0)
            self.tableView.performBatchUpdates({
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
                cell.addSubview(bodyView!)
                UIView.animate(withDuration: 0.3, animations: {
                    bodyView?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + 100, width: cell.bounds.width, height: 0)
                    bodyView?.changeBody(hide: false)
                })
            })
        }
    }
}
