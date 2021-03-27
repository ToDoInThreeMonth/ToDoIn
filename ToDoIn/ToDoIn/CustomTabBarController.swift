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
    private let buttonView = UIView()
    private let button = UIButton()
    private let vectorImage = UIImageView(image: UIImage(named: "vector"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Изменение TabBar'а
        let tabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        
        self.delegate = self
        self.selectedIndex = 0
        
        // Кнопка аккаунта
        button.setBackgroundImage(UIImage(named: "account"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        buttonView.addSubview(button)
        buttonView.addSubview(vectorImage)
        self.tabBar.addSubview(buttonView)
        
        button.addTarget(self, action: #selector(accountButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
//        let tabBarHeight = tabBar.frame.height
        buttonView.pin.bottom(view.pin.safeArea.bottom).hCenter()
        button.pin.bottomCenter(10).size(CGSize(width: 60, height: 60))
        vectorImage.pin.bottomCenter()
//        vectorImage.pin.bottom(view.pin.safeArea.bottom).hCenter()
    }
    

    @objc func accountButtonAction(sender: UIButton) {
        self.selectedIndex = 1
    }
    
}
