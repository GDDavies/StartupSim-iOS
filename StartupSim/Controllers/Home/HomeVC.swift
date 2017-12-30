//
//  HomeVC.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData
import KDCircularProgress
import LinearProgressBar

class HomeVC: UIViewController {

    @IBOutlet weak var startupNameLbl: UILabel!
    @IBOutlet weak var establishedLbl: UILabel!
    
    @IBOutlet weak var ceoAvatarImgView: UIImageView!
    @IBOutlet weak var ceoNameLbl: UILabel!
    @IBOutlet weak var ceoLevelLbl: UILabel!
    @IBOutlet weak var ceoLevelProgressBar: LinearProgressBar!
    
    @IBOutlet weak var shareholderConfLbl: UILabel!
    @IBOutlet weak var employeeMoraleLbl: UILabel!
    @IBOutlet weak var brandRecognitionLbl: UILabel!
    @IBOutlet weak var publicPerceptionLbl: UILabel!
    
    @IBOutlet weak var shareholderConfidenceView: KDCircularProgress!
    @IBOutlet weak var shareholderConfidenceLbl: UILabel!
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = Colours.ThemePrimary
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        self.view.backgroundColor = Colours.LightGrey
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ceoArray = DatabaseManager.doFetchRequest(entity: "Person", context: managedContext!)
        if let ceo = ceoArray?.first as? Person, let name = ceo.name {
            ceoNameLbl.text = name
        }
        
        startupNameLbl.text = StartupMethods.getStartupName(context: managedContext!)

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Startup")
        
        do {
            let startupArray = try managedContext?.fetch(fetchRequest)
            if startupArray?.first == nil {
                let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingViewController
                self.present(vc, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func continueBtnPressed(_ sender: UIButton) {
        DateManager.incrementDate()
    }

}
