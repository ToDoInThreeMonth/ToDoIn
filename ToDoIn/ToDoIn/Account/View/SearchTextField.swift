import UIKit

final class CustomSearchTextField: UITextField {
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "Введите имя"
        returnKeyType = .done
        textColor = .darkTextColor
        backgroundColor = .systemGray6
        font = UIFont.systemFont(ofSize: 18)
        setupLeftView()
        setupRightView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI configure methods
    private func setupRightView() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let rightView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        containerView.addSubview(rightView)
        rightView.tintColor = .systemGray
        self.rightView = containerView
        rightViewMode = .unlessEditing
    }
    
    private func setupLeftView() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 18))
        let vStrokeView = UIView()
        leftView.addSubview(vStrokeView)
        vStrokeView.frame = CGRect(x: 20, y: 0, width: 2, height: 18)
        vStrokeView.backgroundColor = .systemGray3
        vStrokeView.layer.cornerRadius = 5
        self.leftView = leftView
        leftViewMode = .always
    }
    
}
