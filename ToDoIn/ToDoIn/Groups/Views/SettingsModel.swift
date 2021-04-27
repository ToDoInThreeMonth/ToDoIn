import UIKit

struct SettingsModel {
    static var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .accentColor
        return imageView
    }()
    
    static var groupBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentColor
        return view
    }()
    
    static var groupTitle: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .darkTextColor
        textField.textAlignment = .center
        return textField
    }()
    
    static var addUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "addUser")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .accentColor
        button.setTitleColor(.darkTextColor, for: .normal)
        button.tintColor = .lightTextColor
        return button
    }()
    
    static func getGroupBackViewShadow(_ view: UIView) {
        view.addShadow(side: .bottomRight, type: .outside, alpha: 0.15)
        view.addShadow(side: .bottomRight, type: .outside, color: .white, alpha: 1, offset: -10)
        view.addShadow(side: .topLeft, type: .innearRadial, color: .white, power: 0.15, alpha: 1, offset: 10)
        view.addShadow(side: .bottomRight, type: .innearRadial, power: 0.15, offset: 10)
    }
    
    static func getImageViewShadow(_ imageView: UIImageView) {
        imageView.addShadow(side: .topLeft, type: .innearRadial, power: 0.1, alpha: 0.3, offset: 10)
        imageView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.1, alpha: 0.5, offset: 10)
    }
    
    static func getAddButtonShadow(_ button: UIButton) {
        button.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -2)
        button.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
    }
}
