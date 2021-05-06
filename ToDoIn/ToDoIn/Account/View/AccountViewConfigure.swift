import UIKit

struct AccountViewConfigure {
    // Static stored properties
    static var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "nlo")
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    static var userBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkAccentColor
        return view
    }()
    
    static var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Неопознанный объект"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGrayTextColor
        return label
    }()
    
    static var toDoInLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь ToDoIn"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGrayTextColor
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
        view.backgroundColor = .darkRed
        return view
    }()
    
    static var searchTextField: CustomSearchTextField = {
        return CustomSearchTextField()
    }()
    
    static var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closedDoor")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .darkAccentColor
        button.tintColor = .darkTextColor
        button.alpha = 0
        return button
    }()
    
    static var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "offNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Уведомления", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.backgroundColor = .darkAccentColor
        button.tintColor = .darkTextColor
        button.alpha = 0
        return button
    }()
    
    static var settingsBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    
    static var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить друга", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.backgroundColor = .darkAccentColor
        button.tintColor = .darkTextColor
        return button
    }()
    
    static var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.backgroundColor = .systemGray6
        button.tintColor = .darkTextColor
        return button
    }()
    
    // Static functions
    static func getUserBackShadow(_ view: UIView) {
        view.addShadow(side: .bottomRight, type: .outside, alpha: 0.15)
        view.addShadow(side: .bottomRight, type: .outside, color: .white, alpha: 1, offset: -10)
        view.addShadow(side: .topLeft, type: .innearRadial, color: .white, power: 0.15, alpha: 1, offset: 10)
        view.addShadow(side: .bottomRight, type: .innearRadial, power: 0.15, offset: 10)
    }
    
    static func getUserImageViewShadow(_ imageView: UIImageView) {
        imageView.addShadow(side: .topLeft, type: .innearRadial, power: 0.1, alpha: 0.3, offset: 10)
        imageView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.1, alpha: 0.5, offset: 10)
    }
    
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
