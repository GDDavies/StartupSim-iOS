//
//  CustomSegmentedController.swift
//  StartupSim
//
//  Created by George Davies on 30/12/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIControl {
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedButtonIndex = 0
    
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    let buttonTitles = ["Match Info","Match Commentary"]
    
    var newTextColour = UIColor.white
    var textColour: UIColor = UIColor.white
    var selectorTextColour: UIColor = Colours.ThemePrimary
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateView()
    }
    
    public func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        self.backgroundColor = Colours.ThemePrimary
        
        for buttonTitle in buttonTitles {
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
