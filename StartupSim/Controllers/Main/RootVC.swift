//
//  MainVC.swift
//  StartupSim
//
//  Created by George Davies on 28/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int)
}

class RootViewController: UITabBarController, UITabBarControllerDelegate, CustomTabBarDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let viewControllerTuple: [(storyboard: String, viewController: String)] = [("Home", "MainView"), ("Assets", "ViewAssets"),("People", "ViewEmployees"), ("Performance", "ViewPerformance")]
    
    override func viewDidLoad() {
        self.delegate = self
        
        super.viewDidLoad()
        
        var tempViewControllers = [UIViewController]()
        for menuItem in viewControllerTuple {
            let vc = UIStoryboard(name: menuItem.storyboard, bundle: nil).instantiateViewController(withIdentifier: menuItem.viewController)
            let nc = UINavigationController(rootViewController: vc)
            tempViewControllers.append(nc)
        }
        self.viewControllers = tempViewControllers
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        var yPosition = self.tabBar.frame.origin.y
        let bottomInset: CGFloat?
        
        self.tabBar.isHidden = true
        self.selectedIndex = 2
        if #available(iOS 11.0, *) {
            if (UIWindow(frame: UIScreen.main.bounds).safeAreaInsets.top) > CGFloat(0.0) {
                bottomInset = UIWindow(frame: UIScreen.main.bounds).safeAreaInsets.bottom
                yPosition = self.view.frame.height - self.tabBar.frame.height - bottomInset!
                additionalIphonexSetup(bottomInset: bottomInset!)
            }
        }
        let customTabBar = CustomTabBar(frame: CGRect(x: 0.0, y: yPosition, width: self.tabBar.frame.width, height: self.tabBar.frame.height), tabItems: viewControllerTuple)
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)
    }
    
    func additionalIphonexSetup(bottomInset: CGFloat) {
        if #available(iOS 11.0, *) {
            let customTabBarFooter = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - bottomInset, width: self.tabBar.frame.width, height: bottomInset))
            customTabBarFooter.backgroundColor = Colours.Two
            self.view.addSubview(customTabBarFooter)
        }
    }
    
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
}



