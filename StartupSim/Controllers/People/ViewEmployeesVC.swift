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
    var cellContent = [Person]()
    let collapsedHeight: CGFloat = 70
    let expandedHeight: CGFloat = 190
    
    var hireType: Role?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Colours.LightGrey
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
                cellContent.append(person as! Person)
            }
            
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func hireEmployeePressed(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Employee Type", message: nil, preferredStyle: .actionSheet)
        
        let designerAction = UIAlertAction(title: "Designer", style: .default) { (action) in
            self.hireType = .designer
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let devAction = UIAlertAction(title: "Software Dev", style: .default) { (action) in
            self.hireType = .softwareDeveloper
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let projMgrAction = UIAlertAction(title: "Project Manager", style: .default) { (action) in
            self.hireType = .projectManager
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let prodMgrAction = UIAlertAction(title: "Product Manager", style: .default) { (action) in
            self.hireType = .productManager
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let marketingExecAction = UIAlertAction(title: "Marketing Exec", style: .default) { (action) in
            self.hireType = .marketingExecutive
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let accountMgrAction = UIAlertAction(title: "Account Manager", style: .default) { (action) in
            self.hireType = .accountManager
            self.performSegue(withIdentifier: "ShowPotentialHires", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(designerAction)
        actionSheet.addAction(devAction)
        actionSheet.addAction(prodMgrAction)
        actionSheet.addAction(projMgrAction)
        actionSheet.addAction(marketingExecAction)
        actionSheet.addAction(accountMgrAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCellId", for: indexPath) as! EmployeeTableViewCell
        cell.setup(person: cellContent[indexPath.item])
        cell.salaryLbl.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellContent[indexPath.item].expanded ? expandedHeight : collapsedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellContent[indexPath.row].expanded = !cellContent[indexPath.item].expanded
        setCellBody(indexPath, remove: !cellContent[indexPath.row].expanded)
    }
    
    private func setCellBody(_ indexPath: IndexPath, remove: Bool) {
        let cell = tableView.cellForRow(at: indexPath) as! EmployeeTableViewCell
        if remove {
            
            self.tableView.performBatchUpdates({
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                (cell.viewWithTag(indexPath.row + 1) as? ExpandedCellBodyView)?.changeBody(hide: true)
            }, completion: { bool in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.viewWithTag(indexPath.row + 1)?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + self.collapsedHeight, width: cell.bounds.width, height: 0)
                }, completion: { _ in
                    cell.viewWithTag(indexPath.row + 1)?.removeFromSuperview()
                })
            })
        } else {
            let bodyView = UINib(nibName: "ExpandedCellBodyView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ExpandedCellBodyView
            bodyView?.tag = indexPath.row + 1
            bodyView?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + collapsedHeight, width: cell.bounds.width, height: 0)
            bodyView?.setup(person: cellContent[indexPath.row])
            self.tableView.performBatchUpdates({
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
                cell.addSubview(bodyView!)
                UIView.animate(withDuration: 0.3, animations: {
                    bodyView?.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y + self.collapsedHeight, width: cell.bounds.width, height: 0)
                    bodyView?.changeBody(hide: false)
                })
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPotentialHires" {
            if let toViewController = segue.destination as? HireEmployeeVC {
                toViewController.employeeType = hireType
            }
        }
    }
}
