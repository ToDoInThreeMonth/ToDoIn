//
//  UINavigationController + extension.swift
//  ToDoIn
//
//  Created by Philip on 26.04.2021.
//

import UIKit

extension UINavigationController {
    
    
    enum State {
        case main
        case account
        case rooms
    }
    
    // Позволяет настроить кнопки navigation Bar'a в зависимости от экрана)
    func configureBarButtonItems(screen: State, for view: UIViewController) {
        let leftButton = UIBarButtonItem()
        let rightButton = UIBarButtonItem()
        switch screen {
             case .main:
                leftButton.image = UIImage(named: "groupButton")?.withRenderingMode(.alwaysOriginal)
                rightButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
             case .rooms:
                leftButton.image = UIImage(named: "groupButton")?.withRenderingMode(.alwaysOriginal)
                rightButton.image = UIImage(named: "groupButton")?.withRenderingMode(.alwaysOriginal)
             case .account:
                leftButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
                rightButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
             }
        
        view.navigationItem.setLeftBarButton(leftButton, animated: true)
        view.navigationItem.setRightBarButton(rightButton, animated: true)
        }
    
}

