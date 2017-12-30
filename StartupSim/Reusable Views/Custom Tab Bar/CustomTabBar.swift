import UIKit

class CustomTabBar: UIView {
    
    var tabItems: [(storyboard: String, viewController: String)]?
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    var tabBarItemWidth: CGFloat = 0
    var leftMask: UIView?
    var rightMask: UIView?
    
    var containers = [CGRect]()
    
    var timer: Foundation.Timer?
    var fromDate: String?
    var toDate: String?
    
    var selectedTabBarItemIndex: Int!
    var slideAnimationDuration: Double!
    var slideMaskDelay: Double!
    
    var initialTabBarItemIndex: Int!
    
    var numberOfLiveMatches: Int?
    
    var delegate: CustomTabBarDelegate!
    
    init(frame: CGRect, tabItems: [(storyboard: String, viewController: String)]) {
        super.init(frame: frame)
        self.tabItems = tabItems
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        customTabBarItems = []
        tabBarButtons = []
        
        initialTabBarItemIndex = 0
        selectedTabBarItemIndex = initialTabBarItemIndex
        
        slideAnimationDuration = 0.3
        
        containers = createTabBarItemContainers()
        
        createTabBarItemSelectionOverlay(containers: containers)
        createTabBarItemSelectionOverlayMask(containers: containers)
        createTabBarItems(containers: containers)
        
        //numberOfLiveGames()
        //timer = Foundation.Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(numberOfLiveGames), userInfo: nil, repeats: true)

    }
    
    private func createTabBarItemSelectionOverlay(containers: [CGRect]) {
        
        for index in 0 ..< tabItems!.count {
            let container = containers[index]
            
            let view = UIView(frame: container)
            
            let selectedItemOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            selectedItemOverlay.backgroundColor = .white
            view.addSubview(selectedItemOverlay)
            self.addSubview(view)
        }
    }
    
    private func createTabBarItemSelectionOverlayMask(containers: [CGRect]) {
        tabBarItemWidth = self.frame.width / CGFloat(tabItems!.count)
        let leftOverlaySlidingMultiplier = CGFloat(initialTabBarItemIndex) * tabBarItemWidth
        let rightOverlaySlidingMultiplier = CGFloat(initialTabBarItemIndex + 1) * tabBarItemWidth
        
        leftMask = UIView(frame: CGRect(x: 0, y: 0, width: leftOverlaySlidingMultiplier, height: self.frame.height))
        leftMask?.backgroundColor = .white
        rightMask = UIView(frame: CGRect(x: rightOverlaySlidingMultiplier, y: 0, width: tabBarItemWidth * CGFloat(tabItems!.count - 1), height: self.frame.height))
        rightMask?.backgroundColor = .white
        
        self.addSubview(leftMask!)
        self.addSubview(rightMask!)
    }
    
    private func createTabBarItems(containers: [CGRect]) {
        
        for (index, item) in tabItems!.enumerated() {
            let customTabBarItem = CustomTabBarItem(frame: containers[index])
            let title = item.storyboard
            //let liveScoresIndex = item["storyboard"] as? String == "Live Scores" ? index : nil
            customTabBarItem.setup(itemImage: UITabBarItem(title: title, image: UIImage(named: title)?.withRenderingMode(.alwaysTemplate), selectedImage: nil), itemName: title, liveMatches: nil, isSelected: nil) //index == liveScoresIndex ? self.numberOfLiveMatches : nil, isSelected: nil)
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: containers[index].width, height: containers[index].height))
            button.addTarget(self, action: #selector(barItemTapped), for: .touchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
        }
        self.customTabBarItems[initialTabBarItemIndex].iconView.tintColor = Colours.ThemePrimary
        self.customTabBarItems[initialTabBarItemIndex].itemNameLbl.textColor = Colours.ThemePrimary
    }
    
    private func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        for index in 0 ..< tabItems!.count {
            let tabBarContainer = createTabBarContainer(index: index)
            containerArray.append(tabBarContainer)
        }
        return containerArray
    }
    
    private func createTabBarContainer(index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabItems!.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
    @objc private func barItemTapped(sender : UIButton) {
        let index = tabBarButtons.index(of: sender)!
        animateTabBarSelection(from: selectedTabBarItemIndex, to: index)
        selectedTabBarItemIndex = index
        delegate.didSelectViewController(tabBarView: self, atIndex: index)
    }
    
    private func animateTabBarSelection(from: Int, to: Int) {
        let overlaySlidingMultiplier = CGFloat(to - from) * tabBarItemWidth
        
        UIView.animate(withDuration: slideAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.leftMask?.frame.size.width += overlaySlidingMultiplier
        }, completion: nil)
        
        UIView.transition(with: self.customTabBarItems[from].itemNameLbl, duration: slideAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.customTabBarItems[from].itemNameLbl.textColor = .gray
        }, completion: nil)
        
        UIView.transition(with: self.customTabBarItems[to].itemNameLbl, duration: slideAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.customTabBarItems[to].itemNameLbl.textColor = Colours.ThemePrimary
        }, completion: nil)
        
        UIView.animate(withDuration: slideAnimationDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.rightMask?.frame.origin.x += overlaySlidingMultiplier
            self.rightMask?.frame.size.width += -overlaySlidingMultiplier
            self.customTabBarItems[from].iconView.tintColor = .gray
            self.customTabBarItems[to].iconView.tintColor = Colours.ThemePrimary
        }, completion: nil)
    }

//    @objc private func numberOfLiveGames() {
//                
//        let task = URLSession.shared.dataTask(with: feedURL.getLiveScores(), completionHandler: { (data, response, error) in
//            if error == nil {
//                if let d = data, let j = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions()), let json = j as? [String:AnyObject], let matches = json["data"] as? [[String:Any]]{
//                    var liveMatches = 0
//                    for match in matches {
//                        // model/enum?
//                        if MatchStatus.matchIsLive(match: match) {
//                            liveMatches += 1
//                        }
//                    }
//                    // Only update tab bar item if number of games has changed
//                    if liveMatches != self.numberOfLiveMatches {
//                        self.numberOfLiveMatches = liveMatches
//                        self.updateTabBarItem(index: 3)
//                    }
//                }
//            } else {
//                debugPrint("Network error")
//            }
//        })
//        task.resume()
//    }
    
    @objc private func updateTabBarItem(index: Int) {
        OperationQueue.main.addOperation {
            let customTabBarItem = CustomTabBarItem(frame: self.containers[index])
            
            if let items = self.tabItems {
                let title = items[index].storyboard
                customTabBarItem.setup(itemImage: UITabBarItem(title: title, image: UIImage(named: title)?.withRenderingMode(.alwaysTemplate), selectedImage: nil), itemName: title, liveMatches: self.numberOfLiveMatches, isSelected: self.selectedTabBarItemIndex == index ? true : false)
                
                if let customTBItem = self.viewWithTag(40) {
                    customTBItem.removeFromSuperview()
                }
                
                self.addSubview(customTabBarItem)
                customTabBarItem.tag = 40
            }
            self.customTabBarItems.remove(at: index)
            self.customTabBarItems.insert(customTabBarItem, at: index)
            
            if let button = customTabBarItem.viewWithTag(41) {
                button.removeFromSuperview()
            }
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.containers[index].width, height: self.containers[index].height))
            button.addTarget(self, action: #selector(self.barItemTapped), for: .touchUpInside)
            button.tag = 41
            
            customTabBarItem.addSubview(button)
            self.tabBarButtons.remove(at: index)
            self.tabBarButtons.insert(button, at: index)
        }
    }
    
}
