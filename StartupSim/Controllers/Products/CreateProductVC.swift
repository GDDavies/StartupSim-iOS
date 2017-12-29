//
//  CreateProductVC.swift
//  StartupSim
//
//  Created by George Davies on 29/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class CreateProductVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MembershipTextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CreateProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateProductCellId")
    }

    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateProductCellId", for: indexPath) as! CreateProductTableViewCell
        cell.textField.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.textField.fieldType = .name
            cell.textField.placeholder = "Product Name"
        default:
            cell.textField.fieldType = .standard
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
