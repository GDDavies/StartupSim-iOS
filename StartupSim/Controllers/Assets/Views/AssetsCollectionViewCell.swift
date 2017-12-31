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
        
        self.addShadow()
        
        iconContainerView.layer.cornerRadius = iconContainerView.frame.width / 2
        iconContainerView.backgroundColor = Colours.ThemeSecondary.withAlphaComponent(0.1)
    }
    
    func setup(contents: AssetCellContents) {
        assetItemLbl.text = contents.title
        assetItemLbl.isHidden = false
        assetIconImgView.image = UIImage(named: contents.iconString)
    }
}
