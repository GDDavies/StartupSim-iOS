//
//  HomeVC.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    @IBOutlet weak var startupNameLbl: UILabel!
    @IBOutlet weak var ceoAvatarImgView: UIImageView!
    
    @IBOutlet weak var shareholderConfLbl: UILabel!
    @IBOutlet weak var employeeMoraleLbl: UILabel!
    @IBOutlet weak var brandRecognitionLbl: UILabel!
    @IBOutlet weak var publicPerceptionLbl: UILabel!
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        startupNameLbl.text = StartupMethods.getStartupName(context: managedContext!)
    }

    @IBAction func continueBtnPressed(_ sender: UIButton) {
    }

}
