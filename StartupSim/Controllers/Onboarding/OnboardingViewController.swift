//
//  OnboardingViewController.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MembershipTextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        print(appDelegate?.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)
        managedContext = appDelegate?.persistentContainer.viewContext

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "FirstOnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirstOnboardingCellId")
    }

    @IBAction func nextCellPressed(_ sender: UIButton) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            let cell = collectionView.cellForItem(at: indexPath!) as! FirstOnboardingCollectionViewCell
            if indexPath!.item == 0 {
                PeopleMethods.createCEO(name: cell.nameTxtField.text, context: managedContext!)
                collectionView.scrollToItem(at: IndexPath(item: indexPath!.item + 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
                pageCtrl.currentPage = indexPath!.item + 1
            } else {
                StartupMethods.createStartup(name: cell.nameTxtField.text, context: managedContext!)
                self.dismiss(animated: true, completion: {
                    // TODO Reload home VC
                })
            }
        }
        do {
            try managedContext?.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func previousCellPressed(_ sender: UIButton) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            collectionView.scrollToItem(at: IndexPath(item: indexPath!.item - 1, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            pageCtrl.currentPage = indexPath!.item - 1
        }
        do {
            try managedContext?.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstOnboardingCellId", for: indexPath) as! FirstOnboardingCollectionViewCell
        cell.nameTxtField.delegate = self
        cell.nameTxtField.fieldType = .name
        if indexPath.row == 0 {
            cell.headerLbl.text = "Welcome to StartupSim. Please enter your name."
            cell.nameTxtField.placeholder = "Your name"
        } else {
            cell.headerLbl.text = "Please enter your Startup's name."
            cell.nameTxtField.placeholder = "Your startup name"
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            pageCtrl.currentPage = indexPath!.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
