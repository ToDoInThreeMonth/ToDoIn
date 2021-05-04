import UIKit

struct AccountViewConfigure {
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
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
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
        button.setTitle("Выйти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        button.tintColor = UIColor(red: 2 / 255, green: 44 / 255, blue: 114 / 255, alpha: 1)
        return button
    }()
    
    static var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "turnedNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Уведомления", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        button.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        button.tintColor = UIColor(red: 2 / 255, green: 44 / 255, blue: 114 / 255, alpha: 1)
        return button
    }()
    
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
        button.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -2)
        button.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
    }
}
