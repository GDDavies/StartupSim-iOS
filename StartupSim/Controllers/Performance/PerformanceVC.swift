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
    private var lastContentOffset: CGFloat = 0
    
    var delegate: CollectionViewDelegate!
    
    @IBOutlet weak var customSegmentedControl: CustomSegmentedControl!
    
    @IBAction func test(_ sender: CustomSegmentedControl) {
        collectionView.scrollToItem(at: IndexPath(item: sender.selectedButtonIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.LightGrey
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "PerformaceSummaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PerformanceSummaryCellId")
    }

    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Hardcoded.performanceSwipeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerformanceSummaryCellId", for: indexPath) as! PerformaceSummaryCollectionViewCell
        if indexPath.item % 2 != 0 {
            cell.backgroundColor = .red
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            let attributes = collectionView.layoutAttributesForItem(at: indexPath!)
            let frame = collectionView.convert(attributes!.frame, to: self.collectionView.superview)
            var direction: ScrollDirection?
            let indexes = collectionView.indexPathsForVisibleItems

            if indexPath!.item != 0 || indexPath!.item % 2 != 0 {
                
                if (self.lastContentOffset > scrollView.contentOffset.x) {
                    let max = indexes.max()
                    selectedIndex = max!.item - 1
                    direction = .left
                }
                else if (self.lastContentOffset < scrollView.contentOffset.x) {
                    if indexes.indices.contains(1) {
                        let max = indexes.max()
                        selectedIndex = max!.item
                    }
                    direction = .right
                }
                self.lastContentOffset = scrollView.contentOffset.x
                if let dir = direction {
                    delegate.scrollingToViewContoller(index: selectedIndex!, frame: frame, direction: dir)
                }
            }
        }
    }
}
