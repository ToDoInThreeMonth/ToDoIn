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
        case groups
        case groupsDetail
    }
    
    // Позволяет настроить кнопки navigation Bar'a в зависимости от экрана)
    func configureBarButtonItems(screen: State, for view: UIViewController) {
        self.navigationBar.barTintColor = UIColor.accentColor
        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.darkTextColor, .font : UIFont(name: "Georgia", size: 24) as Any]
        switch screen {
        case .main:
            let addSectionButtonImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let addSectionButton = UIBarButtonItem(image: addSectionButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addSectionButton, animated: true)
            view.title = "Главная"
        case .groups:
            let addRoomButtonImage =  UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let addRoomButton = UIBarButtonItem(image: addRoomButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addRoomButton, animated: true)
            view.title = "Комнаты"
        case .account:
            let leftButtonImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: nil, action: nil)
            let rightButtonImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setLeftBarButton(leftButton, animated: true)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
            view.title = "Аккаунт"
        case .groupsDetail:
            let rightButtonA = UIButton(type: .system)
            rightButtonA.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            rightButtonA.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
            rightButtonA.imageView?.contentMode = .scaleAspectFit
            rightButtonA.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
            
            let rightButtonB = UIButton(type: .system)
            rightButtonB.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            rightButtonB.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
            rightButtonB.imageView?.contentMode = .scaleAspectFit
            rightButtonB.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
            
            let buttonsStackView = UIStackView(arrangedSubviews: [rightButtonA, rightButtonB])
            buttonsStackView.distribution = .equalSpacing
            buttonsStackView.spacing = 8
            buttonsStackView.alignment = .center
            buttonsStackView.axis = .horizontal

            let rightButtons = UIBarButtonItem(customView: buttonsStackView)
            view.navigationItem.rightBarButtonItem = rightButtons
            
            view.title = "Имя Комнаты"
        }
    }
}


