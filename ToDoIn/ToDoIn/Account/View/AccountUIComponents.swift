import UIKit

struct AccountUIComponents {
    
    // MARK: - Properties
    
    static var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Неопознанный объект"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkTextColor
        return label
    }()
    
    static var toDoInLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь ToDoIn"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightTextColor
        return label
    }()
    
    static var friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Друзья"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkTextColor
        return label
    }()
    
    static var friendUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightRedColor
        return view
    }()
    
    static var searchTextField: CustomSearchTextField = {
        return CustomSearchTextField()
    }()
    
    static var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить друга", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.backgroundColor = .accentColor
        button.tintColor = .darkTextColor
        return button
    }()
    
    static var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.setTitle("Добавить друга", for: .normal)
        button.setTitleColor(.darkTextColor, for: .normal)
        button.backgroundColor = .accentColor
        button.tintColor = .darkTextColor
        return button
    }()
    
    static var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closedDoor")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .accentColor
        button.tintColor = .darkTextColor
        button.alpha = 0
        return button
    }()
    
    static var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "offNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Уведомления", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.backgroundColor = .accentColor
        button.tintColor = .darkTextColor
        button.alpha = 0
        return button
    }()
    
    static var settingsBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    
    // MARK: - Handlers
    
    static func getSearchTFShadow(_ textField: UITextField) {
        textField.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        textField.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
    
    static func getSettingButtonShadow(_ button: UIButton) {
        button.addShadow(type: .outside, power: 3, alpha: 0.3, offset: 0)
    }
    
    static func getAddButtonShadow(_ button: UIButton) {
        button.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        button.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
    
    static func getSettingButtonGradiend(_ button: UIButton) {
        button.addLinearGradiend()
    }
    
    static func getSettingsViewBlur(_ view: UIView) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        blurredEffectView.alpha = 0.8
        
        view.addSubview(blurredEffectView)
    }
    
    static func getBasicViewShadow(_ view: UIView) {
        view.addShadow(type: .outside, power: 10, alpha: 0.2, offset: 1)
        view.addShadow(type: .outside, color: .white, power: 2, alpha: 1, offset: -1)
        view.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
}
