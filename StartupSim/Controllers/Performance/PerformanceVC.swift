//
//  PerformanceVC.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit
import CoreData

class PerformanceVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex: Int?
    
    @IBAction func test(_ sender: CustomSegmentedControl) {
        print(sender.selectedButtonIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.LightGrey
        collectionView.register(UINib(nibName: "PerformaceSummaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PerformanceSummaryCellId")
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerformanceSummaryCellId", for: indexPath) as! PerformaceSummaryCollectionViewCell
        return cell
    }

}
