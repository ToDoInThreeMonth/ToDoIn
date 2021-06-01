import UIKit
import PinLayout

protocol FriendsTableViewOutput: AnyObject {

    func showErrorAlertController(with message: String)
    
    func reloadView()
    
    func getFriend(by index: Int) -> User?
    func getAllFriends() -> [User]?
    func getPhoto(by url: String, completion: @escaping (UIImage) -> Void)
}

protocol AddFriendViewOutput: AnyObject {
    func addNewFriend(_ mail: String)
    func dismissAddNewFriendView()
    func cleanFriendTextField()
    func cleanErrorLabel()
}

protocol AccountViewProtocol: FriendsTableViewOutput, AddFriendViewOutput {
    func showError(with error: String)
    func setUp(with user: User)
}

final class AccountController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: AccountPresenterProtocol?
    
    private lazy var userImageView = CustomImageView()
    private lazy var userNameLabel = AccountUIComponents.userNameLabel
    private lazy var toDoInLabel = AccountUIComponents.toDoInLabel
    private lazy var friendsLabel = AccountUIComponents.friendsLabel
    private lazy var friendUnderlineView = AccountUIComponents.friendUnderlineView
    private lazy var settingsBackgroundView = AccountUIComponents.settingsBackgroundView
    private lazy var tapAddFriendRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFriendButtonTapped))
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить друга", for: .normal)
        button.titleLabel?.font = UIFont(name: "Georgia", size: 14)
        button.tintColor = .darkTextColor
        button.backgroundColor = .accentColor
        button.addTarget(self, action: #selector(addFriendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var friendsTVDelegate = FriendsTVDelegate()
    private lazy var friendsTVDataSource = FriendsTVDataSource(controller: self)
    private lazy var friendsTableView: UITableView = {
        let tableView = FriendsTableView(frame: .zero, style: .plain)
        tableView.dataSource = friendsTVDataSource
        tableView.delegate = friendsTVDelegate
        return tableView
    }()
    
    private lazy var addFriendView = AddFriendView(controller: self)
    
    private var isAddViewHidden = true
    private var isSettingMenuHidden = true
    
    private struct LayersConstants {
        static let settingsContentLeft: CGFloat = 20
        static let settingsContentRight: CGFloat = 5
        static let settingImageRight: CGFloat = 45
        static let scrollInsetBottom: CGFloat = 15
    }
    
    private struct AnimationConstants {
        static var exitButtonAlpha: CGFloat = 1
        static var notificationButtonAlpha: CGFloat = 1
        static var backgroundAlpha: CGFloat = 0.2
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoadView()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        setupViews()
        setupNavigationItem()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
        setupInsets()
    }
    
    // MARK: - Configures
    
    private func setupViews() {
        view.backgroundColor = .accentColor
        view.addSubviews(userImageView,
                         friendsTableView,
                         userNameLabel,
                         toDoInLabel,
                         friendsLabel,
                         addFriendButton,
                         friendUnderlineView,
                         settingsBackgroundView,
                         addFriendView)
    }
    
    private func setupLayouts() {
        userImageView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
        
        userNameLabel.pin
            .top(to: userImageView.edge.bottom)
            .hCenter()
            .marginTop(20)
            .size(CGSize(width: 300, height: 24))
        
        toDoInLabel.pin
            .top(to: userNameLabel.edge.bottom)
            .hCenter()
            .size(CGSize(width: 300, height: 24))
        
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
        
        friendsTableView.pin
            .top(to: friendUnderlineView.edge.bottom)
            .start(20)
            .end(20)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
        
        addFriendButton.pin
            .end(40)
            .start(to: friendsLabel.edge.end)
            .marginStart(30)
            .bottom(to: friendUnderlineView.edge.bottom)
            .top(to: friendsLabel.edge.top)
            .marginTop(-5)
        
        settingsBackgroundView.pin
            .all()
        
        addFriendView.pin
            .vCenter()
            .horizontally(20)
            .height(300)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .account, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(exitButtonTapped)
    }
    
    private func configureViews() {
        if addFriendButton.layer.cornerRadius == 0 {
            
            addFriendButton.layer.cornerRadius = 20
            AccountUIComponents.getSettingButtonShadow(addFriendButton)
            AccountUIComponents.getSettingButtonGradiend(addFriendButton)
            
            AccountUIComponents.getSettingsViewBlur(settingsBackgroundView)
            
            addFriendView.layer.cornerRadius = 20
            AccountUIComponents.getBasicViewShadow(addFriendView)
        }
    }
    
    private func setupInsets() {
        friendsTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                      left: 0,
                                                                      bottom: LayersConstants.scrollInsetBottom,
                                                                      right: 0)
    }
    
    // MARK: - Handlers
    
    @objc
    private func addFriendButtonTapped() {
        addViewAnimation()
    }
    
    @objc
    private func exitButtonTapped() {
        presenter?.showExitAlertController { [weak self] in
            guard let self = self else { return }
            self.presenter?.exitButtonTapped()
        }
    }
    
    private func addViewAnimation() {
        var alpha: CGFloat = 0
        dismissKeyboard()
        
        if isAddViewHidden == true {
            alpha = 1
            self.addFriendView.isHidden = false
            self.settingsBackgroundView.isHidden = false
            settingsBackgroundView.addGestureRecognizer(tapAddFriendRecognizer)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) { [weak self] in
            self?.settingsBackgroundView.alpha = alpha
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut]) { [weak self] in
            self?.addFriendView.alpha = alpha
        } completion: { [weak self] _ in
            guard let self = self else { return }
            if self.isAddViewHidden == true {
                self.addFriendView.isHidden = true
                self.settingsBackgroundView.gestureRecognizers?.removeAll()
            }
        }
        isAddViewHidden.toggle()
    }
    
    func setPresenter(presenter: AccountPresenterProtocol, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}

extension AccountController: AccountViewProtocol {
    
    func getPhoto(by url: String, completion: @escaping (UIImage) -> Void) {
        presenter?.loadImage(url: url) { (image) in
            completion(image)
        }
    }

    func showErrorAlertController(with message: String) {
        presenter?.showErrorAlertController(with: message)
    }
    
    func showError(with error: String) {
        addFriendView.showError(with: error)
    }
    
    func cleanErrorLabel() {
        addFriendView.cleanErrorLabel()
    }
    
    func cleanFriendTextField() {
        addFriendView.cleanFriendTextField()
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }

    func setUp(with user: User) {
        userNameLabel.text = user.name
        toDoInLabel.text = user.email
        if user.image != "default" {
            presenter?.loadImage(url: user.image) { (image) in
                self.userImageView.setImage(with: image)
            }
        }
    }
    
    func getFriend(by index: Int) -> User? {
        presenter?.getFriend(by: index)
    }
    
    func getAllFriends() -> [User]? {
        presenter?.getAllFriends()
    }
    
    func addNewFriend(_ email: String) {
        presenter?.addNewFriend(email)
    }
    
    func dismissAddNewFriendView() {
        addViewAnimation()
    }

}
