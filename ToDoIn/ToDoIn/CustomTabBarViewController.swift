//
//  CustomTabBarViewController.swift
//  ToDoIn
//
//  Created by Дарья on 26.03.2021.
//

import Foundation
import UIKit
import PinLayout

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
    private let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        
        self.delegate = self
        self.selectedIndex = 0
        
//        setUpAccountButton(imageName: "main", frame: CGRect(x: view.center.x, y: -20, width: 60, height: 60))
        
        button.setBackgroundImage(UIImage(named: "main"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.tabBar.addSubview(button)
        
        button.addTarget(self, action: #selector(accountButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
        button.pin.bottom(5).hCenter(3).size(CGSize(width: 80, height: 80))
    }
    
    
    func setUpAccountButton(imageName: String, frame: CGRect) {
        let button = UIButton(frame: frame)
        
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.tabBar.addSubview(button)
        
        button.addTarget(self, action: #selector(accountButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    
//    @objc func mainButtonAction(sender: UIButton) {
//        self.selectedIndex = 0
//    }
//    

    @objc func accountButtonAction(sender: UIButton) {
        self.selectedIndex = 1
    }
    

//    @objc func settingsButtonAction(sender: UIButton) {
//        self.selectedIndex = 2
//    }
    
}
