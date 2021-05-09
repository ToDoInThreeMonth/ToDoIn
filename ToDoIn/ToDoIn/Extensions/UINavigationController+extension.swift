import UIKit

extension UINavigationController {
    
    
    enum State {
        case main
        case account
        case rooms
        case roomsDetail
        case roomSettings
        case login
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
        case .rooms:
            let addRoomButtonImage =  UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let addRoomButton = UIBarButtonItem(image: addRoomButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addRoomButton, animated: true)
            view.title = "Комнаты"
        case .account:
            let rightButtonImage = UIImage(named: "accountSettings")?.withRenderingMode(.alwaysOriginal)
            let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
            view.title = "Аккаунт"
        case .roomsDetail:
            let rightButtonAImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let rightButtonBImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let rightButtonA = UIBarButtonItem(image: rightButtonAImage, style: .plain, target: nil, action: nil)
            let rightButtonB = UIBarButtonItem(image: rightButtonBImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButtonItems([rightButtonA, rightButtonB], animated: true)
            view.title = "Имя Комнаты"
        case .roomSettings:
            let addUserToRoomButtonImage =  UIImage(named: "addUser")?.withRenderingMode(.alwaysOriginal)
            let addUserButton = UIBarButtonItem(image: addUserToRoomButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addUserButton, animated: true)
        case .login:
            view.title = "Аккаунт"
        }
    }
}
