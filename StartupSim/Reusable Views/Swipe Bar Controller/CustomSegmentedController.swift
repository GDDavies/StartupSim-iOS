//
//  CustomSegmentedController.swift
//  StartupSim
//
//  Created by George Davies on 30/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

protocol CollectionViewDelegate {
    func scrollingToViewContoller(index: Int, frame: CGRect, direction: ScrollDirection)
}

class CustomSegmentedControl: UIControl, CollectionViewDelegate {

    var buttons = [UIButton]()
    var selector: UIView!
    var selectedButtonIndex = 0
    
    var delegate: CollectionViewDelegate!

    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var newTextColour = UIColor.white
    var textColour: UIColor = UIColor.white
    var selectorTextColour: UIColor = Colours.ThemePrimary
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        (self.parentViewController as? PerformanceVC)?.delegate = self
    }
    
    public func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        self.backgroundColor = Colours.ThemePrimary
        
        for buttonTitle in Hardcoded.performanceSwipeItems {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(newTextColour, for: .normal)
            button.titleLabel?.font = Fonts.NormalFnt(12)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColour, for: .normal)
        
        let selectorWidth = UIScreen.main.bounds.width / CGFloat(buttons.count)
        let selectorHeight = self.frame.height
        selector = UIView(frame: CGRect(x: 0.0, y: 0.0, width: selectorWidth, height: selectorHeight))
        selector.backgroundColor = .white
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    @objc func buttonTapped(button: UIButton) {
        moveSelector(button)
    }
    
    private func moveSelector(_ button: UIButton? = nil) {
        
        var buttonOne: UIButton?
        
        if button == nil {
            buttonOne = buttons[selectedButtonIndex]
            buttons.forEach{ $0.setTitleColor(newTextColour, for: .normal) }
            
            let selectorStartPosition = (frame.width / CGFloat(buttons.count)) * CGFloat(selectedButtonIndex)
            UIView.animate(withDuration: 0.3, animations: {
                self.selector.frame.origin.x = selectorStartPosition
            })
            buttonOne?.setTitleColor(selectorTextColour, for: .normal)
        } else {
        
            for (buttonIndex, btn) in buttons.enumerated() {
                btn.setTitleColor(newTextColour, for: .normal)
                
                if btn == button {
                    selectedButtonIndex = buttonIndex
                    let selectorStartPosition = (frame.width / CGFloat(buttons.count)) * CGFloat(buttonIndex)
                    UIView.animate(withDuration: 0.3, animations: {
                        self.selector.frame.origin.x = selectorStartPosition
                    })
                    btn.setTitleColor(selectorTextColour, for: .normal)
                }
            }
            sendActions(for: .valueChanged)
        }
    }
    
    var saveX = true
        
    func scrollingToViewContoller(index: Int, frame: CGRect, direction: ScrollDirection) {
//        print("Selected index = \(index)")
//        print("Screen width = \(self.frame.width)")
        
        var width: CGFloat?
        var x: CGFloat?

        if direction == .right {
            
            switch index {
            case 1:
                width = self.frame.width / 2
            case 2:
                width = -self.frame.width / 2
            default:
                width = self.frame.width / 2
            }
            
            if frame.origin.x < width! {
                if selectedButtonIndex != index {
                    selectedButtonIndex = index
                    moveSelector()
                }
            }
        } else if direction == .left {
            
            switch index {
            case 1:
                width = -self.frame.width / 2
            case 2:
                width = self.frame.width / 2
            default:
                width = self.frame.width / 2
            }
            print("Index = \(index)")
            print("X = \(frame.origin.x)")
            print("Width = \(width!)")
            if !(-10...10).contains(Int(frame.origin.x)) {
                if frame.origin.x > width! {
                    if self.selectedButtonIndex != index {
                        self.selectedButtonIndex = index
                        self.moveSelector()
                    }
                }
            }
        }
    }
}







