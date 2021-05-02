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
        case roomsDetail
    }
    
    // Позволяет настроить кнопки navigation Bar'a в зависимости от экрана)
    func configureBarButtonItems(screen: State, for view: UIViewController) {
        self.navigationBar.barTintColor = UIColor.accentColor
        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.darkTextColor, .font : UIFont(name: "Georgia", size: 24) as Any]
        switch screen {
        case .main:
            let rightButton = UIBarButtonItem()
            rightButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
        case .rooms:
            let rightButton = UIBarButtonItem()
            rightButton.image = UIImage(named: "groupButton")?.withRenderingMode(.alwaysOriginal)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
        case .account:
            let leftButton = UIBarButtonItem()
            let rightButton = UIBarButtonItem()
            leftButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
            rightButton.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
            view.navigationItem.setLeftBarButton(leftButton, animated: true)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
        case .roomsDetail:
            let rightButtonA = UIBarButtonItem()
            let rightButtonB = UIBarButtonItem()
            rightButtonA.image = UIImage(named: "groupButton")?.withRenderingMode(.alwaysOriginal)
            rightButtonB.image = UIImage(named: "addSection")?.withRenderingMode(.alwaysOriginal)
            view.navigationItem.setRightBarButtonItems([rightButtonA, rightButtonB], animated: true)
        }
    }
    
}


