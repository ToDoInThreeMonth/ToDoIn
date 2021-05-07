import UIKit

class AddFriendView: UIView {
    private weak var controller: AddFriendViewOutput?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkTextColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Здесь вы можете добавить друга"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightTextColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Введите почту"
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = CustomSearchTextField()
        textField.rightView = nil
        textField.placeholder = "randomFriend@email.com"
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = AccountViewConfigure.addButton
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.alpha = 0
        return label
    }()
        
    
    init(controller: AddFriendViewOutput) {
        super.init(frame: .zero)
        self.controller = controller
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupEffects()
    }
    
    private func setupViews() {
        isHidden = true
        backgroundColor = .accentColor
        addSubviews(titleLabel,
                    emailLabel,
                    emailTextField,
                    errorLabel,
                    addButton)
    }
    
    private func setupLayouts() {
        titleLabel.pin
            .top(40)
            .horizontally(20)
            .sizeToFit(.width)
        emailTextField.pin
            .vCenter()
            .horizontally(40)
            .height(40)
        emailLabel.pin
            .bottom(to: emailTextField.edge.top)
            .start(to: emailTextField.edge.start)
            .end(to: emailTextField.edge.end)
            .marginBottom(10)
            .sizeToFit(.width)
        errorLabel.pin
            .below(of: emailTextField, aligned: .center)
            .marginTop(15)
            .size(CGSize(width: self.bounds.width - 10, height: 25))
        addButton.pin
            .bottom(20)
            .end(40)
            .start(40)
            .height(40)
    }
    
    private func setupEffects() {
        if emailTextField.layer.cornerRadius == 0 {
            layer.cornerRadius = 20
            addButton.layer.cornerRadius = 20
            emailTextField.layer.cornerRadius = 20
            
            AccountViewConfigure.getSearchTFShadow(emailTextField)
            AccountViewConfigure.getAddButtonShadow(addButton)
            AccountViewConfigure.getSettingButtonGradiend(addButton)
        }
    }
    
    @objc
    private func addButtonTapped() {
        guard let mail = emailTextField.text, !mail.isEmpty else { return }
        controller?.addNewFriend(mail)
        emailTextField.text = ""
    }
    
    func showError(with error: String) {
        errorLabel.text = error
        errorLabel.alpha = 1
    }
    
    func cleanErrorLabel() {
        errorLabel.text = ""
        errorLabel.alpha = 0
    }
}
