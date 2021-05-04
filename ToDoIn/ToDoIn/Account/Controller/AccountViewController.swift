import UIKit
import PinLayout

class AccountViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?
    
    private lazy var userImageView = AccountViewConfigure.userImageView
    private lazy var userBackView = AccountViewConfigure.userBackView
    private lazy var userNameLabel = AccountViewConfigure.userNameLabel
    private lazy var toDoInLabel = AccountViewConfigure.toDoInLabel
    private lazy var friendsLabel = AccountViewConfigure.friendsLabel
    private lazy var friendUnderlineView = AccountViewConfigure.friendUnderlineView
    
    private lazy var searchTextField: UITextField = {
        let textField = AccountViewConfigure.searchTextField
        textField.addTarget(self, action: #selector(searchTFDidChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var exitButton: UIButton = {
        let button = AccountViewConfigure.exitButton
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = AccountViewConfigure.notificationButton
        button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var friendsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: String(describing: AccountTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    struct LayersConstants {
        static let settingsContentLeft: CGFloat = 20
        static let settingsContentRight: CGFloat = 25
        static let settingImageRight: CGFloat = 45
        static let scrollInsetBottom: CGFloat = 15
        static let scrollInsetRight: CGFloat = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViews()
        setupInsets()
    }
    
    private func setupViews() {
        view.backgroundColor = .darkAccentColor
        view.addSubviews(userBackView,
                         userNameLabel,
                         toDoInLabel,
                         friendsLabel,
                         searchTextField,
                         friendUnderlineView,
                         friendsTableView,
                         exitButton,
                         notificationButton)
        userBackView.addSubviews(userImageView)
    }

    private func setupLayouts() {
        userBackView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
            .size(CGSize(width: 150, height: 150))
        userImageView.pin
            .all().margin(20)
        userNameLabel.pin
            .top(to: userBackView.edge.bottom)
            .hCenter()
            .marginTop(20)
            .sizeToFit()
        toDoInLabel.pin
            .top(to: userNameLabel.edge.bottom)
            .hCenter()
            .sizeToFit()
        friendsLabel.pin
            .top(to: toDoInLabel.edge.bottom)
            .start(40)
            .sizeToFit()
            .marginTop(35)
        friendUnderlineView.pin
            .top(to:  friendsLabel.edge.bottom)
            .marginTop(3)
            .hCenter(to: friendsLabel.edge.hCenter)
            .width(friendsLabel.bounds.width + 20)
            .height(3)
        searchTextField.pin
            .end(40)
            .start(to: friendsLabel.edge.end)
            .marginStart(30)
            .bottom(to: friendUnderlineView.edge.bottom)
            .top(to: friendsLabel.edge.top)
            .marginTop(-5)
        notificationButton.pin
            .top(to: friendUnderlineView.edge.bottom)
            .end(-20)
            .width(130)
            .height(40)
            .marginTop(20)
        exitButton.pin
            .top(to: notificationButton.edge.bottom)
            .end(-20)
            .width(130)
            .height(40)
            .marginTop(20)
        friendsTableView.pin
            .top(to: friendUnderlineView.edge.bottom)
            .start(20)
            .end(to: exitButton.edge.start)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    private func configureViews() {
        userBackView.makeRound()
        AccountViewConfigure.getUserBackShadow(userBackView)
        
        userImageView.makeRound()
        AccountViewConfigure.getUserImageViewShadow(userImageView)
        
        searchTextField.layer.cornerRadius = 20
        AccountViewConfigure.getSearchTFShadow(searchTextField)
        
        [exitButton, notificationButton].forEach{
            $0.layer.cornerRadius = 15
            AccountViewConfigure.getSettingButtonShadow($0)
        }
    }
    
    private func setupInsets() {
        friendsTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                      left: 0,
                                                                      bottom: LayersConstants.scrollInsetBottom,
                                                                      right: friendsTableView.bounds.width - LayersConstants.scrollInsetRight)
        [exitButton, notificationButton].forEach{
            guard let imageView = $0.imageView else { return }
            
            $0.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                left: LayersConstants.settingsContentLeft,
                                                bottom: 0,
                                                right: LayersConstants.settingsContentRight)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: $0.frame.width - LayersConstants.settingImageRight - imageView.frame.width)
        }
    }
    
    @objc
    private func exitButtonTapped() {
        let alertTitle = "Выход из аккаунта"
        let alertMessage = "Вы действительно хотите выйти ?"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .logOut)
     
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc
    private func notificationButtonTapped() {
    }
    
    @objc
    private func searchTFDidChanged() {
    }
}

//MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendBase.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as? AccountTableViewCell
        guard let safeCell = cell else {
            let alertTitle = "Неожиданный сбой"
            let alertMessage = "Ячейки с пользователями не могут быть созданы"
            let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .error)
            present(alertVC, animated: true)
            return UITableViewCell()}
        
        safeCell.friend = FriendBase.friends[indexPath.row]
        return safeCell
    }
        
}

extension AccountViewController: UITableViewDelegate {

}
