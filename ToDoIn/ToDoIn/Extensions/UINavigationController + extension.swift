import UIKit

extension UINavigationController {
    
    
    enum State {
        case main
        case account
        case groups
        case groupDetail
        case groupSettings
        case login
    }
    
    // Позволяет настроить кнопки navigation Bar'a в зависимости от экрана)
    func configureBarButtonItems(screen: State, for view: UIViewController, rightButton: UIButton = UIButton(), leftButton: UIButton = UIButton()) {

        self.navigationBar.barTintColor = UIColor.accentColor

        self.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.darkTextColor, .font : UIFont(name: "Georgia", size: 24) as Any]
        switch screen {
        case .main:
            view.title = "Главная"
        case .groups:
            let addRoomButtonImage =  UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
            let addRoomButton = UIBarButtonItem(image: addRoomButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addRoomButton, animated: true)
            view.title = "Комнаты"
        case .account:
            let rightButtonImage = UIImage(named: "closedDoor")?.withRenderingMode(.alwaysOriginal)
            let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(rightButton, animated: true)
            view.title = "Аккаунт"
        case .groupDetail:
            let rightButtonA = rightButton
            rightButtonA.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            rightButtonA.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
            rightButtonA.imageView?.contentMode = .scaleAspectFit
            rightButtonA.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
            
            let rightButtonB = leftButton
            rightButtonB.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            rightButtonB.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), for: .normal)
            rightButtonB.imageView?.contentMode = .scaleAspectFit
            rightButtonB.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
            
            let buttonsStackView = UIStackView(arrangedSubviews: [rightButtonA, rightButtonB])
            buttonsStackView.distribution = .equalSpacing
            buttonsStackView.spacing = 8
            buttonsStackView.alignment = .center
            buttonsStackView.axis = .horizontal
            
            let rightButtons = UIBarButtonItem(customView: buttonsStackView)
            view.navigationItem.rightBarButtonItem = rightButtons
        case .groupSettings:
            let addUserToRoomButtonImage =  UIImage(named: "addUser")?.withRenderingMode(.alwaysOriginal)
            let addUserButton = UIBarButtonItem(image: addUserToRoomButtonImage, style: .plain, target: nil, action: nil)
            view.navigationItem.setRightBarButton(addUserButton, animated: true)
        case .login:
            view.title = "Аккаунт"
        }
    }
}
