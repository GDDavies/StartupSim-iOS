//
//  AssetsCollectionViewCell.swift
//  StartupSim
//
//  Created by George Davies on 30/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

struct AssetCellContents {
    var title: String
    var iconString: String
    
    init(title: String, iconString: String) {
        self.title = title
        self.iconString = iconString
    }
}

class AssetsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var assetItemLbl: UILabel!
    @IBOutlet weak var assetIconImgView: UIImageView!
    @IBOutlet weak var iconContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        assetItemLbl.isHidden = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        //self.layer.cornerRadius = 5.0
        
        iconContainerView.layer.cornerRadius = iconContainerView.frame.width / 2
        iconContainerView.backgroundColor = Colours.ThemeSecondary.withAlphaComponent(0.1)
    }
    
    func setup(contents: AssetCellContents) {
        assetItemLbl.text = contents.title
        assetItemLbl.isHidden = false
        assetIconImgView.image = UIImage(named: contents.iconString)
    }
}
