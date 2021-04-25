import UIKit
import PinLayout

class AccountViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?
    
    private lazy var userImageView = AccountModel.userImageView
    private lazy var userBackView = AccountModel.userBackView
    private lazy var userNameLabel = AccountModel.userNameLabel
    private lazy var toDoInLabel = AccountModel.toDoInLabel
    private lazy var friendsLabel = AccountModel.friendsLabel
    private lazy var friendUnderlineView = AccountModel.friendUnderlineView
    
    private lazy var searchTextField: UITextField = {
        let textField = AccountModel.searchTextField
        textField.addTarget(self, action: #selector(searchTFDidChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var exitButton: UIButton = {
        let button = AccountModel.exitButton
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = AccountModel.notificationButton
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
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
            .width(140)
            .height(40)
            .marginTop(20)
        exitButton.pin
            .top(to: notificationButton.edge.bottom)
            .end(-20)
            .width(140)
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
        AccountModel.getUserBackShadow(userBackView)
        
        userImageView.makeRound()
        AccountModel.getUserImageViewShadow(userImageView)
        
        searchTextField.layer.cornerRadius = 20
        AccountModel.getSearchTFShadow(searchTextField)
        
        [exitButton, notificationButton].forEach{
            $0.layer.cornerRadius = 15
            AccountModel.getSettingButtonShadow($0)
        }
    }
    
    private func setupInsets() {
        friendsTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: friendsTableView.bounds.width - 8)
        [exitButton, notificationButton].forEach{
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 25)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: $0.frame.width - 45 - $0.imageView!.frame.width)
        }
    }
    
    @objc
    private func exitButtonTapped() {
        let alertVC = LogOutAlertController(title: "Выход из аккаунта", message: "Вы действительно хотите выйти?", preferredStyle: .alert)
     
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
        guard let safeCell = cell else { return UITableViewCell() }
        safeCell.friend = FriendBase.friends[indexPath.row]
        return safeCell
    }
        
}

extension AccountViewController: UITableViewDelegate {

}
