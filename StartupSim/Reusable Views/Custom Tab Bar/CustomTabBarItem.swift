import UIKit

class CustomTabBarItem: UIView {

    var iconView: UIImageView!
    var itemNameLbl = UILabel()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(itemImage: UITabBarItem, itemName: String, liveMatches: Int?, isSelected: Bool?) {
        guard let image = itemImage.image else {
            fatalError("add images to tabbar items")
        }
        
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-10-image.size
            .height)/2, width: self.frame.width, height: self.frame.height))
        iconView.image = image
        iconView.sizeToFit()
        
        if let numberOfMatches = liveMatches {
            
            if let badge = iconView.viewWithTag(20), let numberLbl = iconView.viewWithTag(21) {
                badge.removeFromSuperview()
                numberLbl.removeFromSuperview()
            }
            
            if numberOfMatches != 0 {
                let liveGameBadge = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0))
                liveGameBadge.center = CGPoint(x: iconView.frame.maxX - 18, y: iconView.frame.origin.y - 5)
                liveGameBadge.layer.cornerRadius = liveGameBadge.frame.size.width / 2
                liveGameBadge.backgroundColor = .red
                liveGameBadge.clipsToBounds = true
                
                let numberOfLiveGames = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0))
                numberOfLiveGames.center = CGPoint(x: liveGameBadge.center.x, y: liveGameBadge.center.y)
                numberOfLiveGames.textAlignment = .center
                numberOfLiveGames.text = String(describing: numberOfMatches)
                numberOfLiveGames.font = Fonts.BoldFnt(10)
                numberOfLiveGames.textColor = .white
                
                liveGameBadge.tag = 20
                numberOfLiveGames.tag = 21
                
                iconView.addSubview(liveGameBadge)
                iconView.addSubview(numberOfLiveGames)
            }
        }
        if let selected = isSelected, selected == true {
            iconView.tintColor = Colours.ThemePrimary
            itemNameLbl.textColor = Colours.ThemePrimary
        } else {
            iconView.tintColor = .gray
            itemNameLbl.textColor = .gray
        }
        itemNameLbl.text = itemName
        itemNameLbl.textAlignment = .center
        itemNameLbl.translatesAutoresizingMaskIntoConstraints = false
        itemNameLbl.font = Fonts.NormalFnt(10)
        
        if let icon = self.viewWithTag(30), let itemName = self.viewWithTag(31) {
            icon.removeFromSuperview()
            itemName.removeFromSuperview()
        }
        
        self.addSubview(iconView)
        self.addSubview(itemNameLbl)
        
        iconView.tag = 30
        itemNameLbl.tag = 31
        
        let horizontalConstraint = NSLayoutConstraint(item: itemNameLbl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: iconView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: itemNameLbl, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: itemNameLbl, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: itemNameLbl, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15)
        
        self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
}
