import UIKit
import PinLayout

protocol FriendsTableViewOutput: class {

    func showErrorAlertController(with message: String)
    
    func reloadView()
    func setUp(with user: User)
    
    func getFriend(by index: Int) -> User?
    func getAllFriends() -> [User]?
}

protocol AddFriendViewOutput: class {
    func addNewFriend(_ mail: String)
    func dismissAddNewFriendView()
}

protocol AccountView: FriendsTableViewOutput, AddFriendViewOutput {
    func showError(with error: String)
}

class AccountController: UIViewController {
    
    // Stored properties
    private var presenter: AccountViewPresenter?
    
    // Lazy stored properties
    private lazy var userImageView = AccountViewConfigure.userImageView
    private lazy var userBackView = AccountViewConfigure.userBackView
    private lazy var userNameLabel = AccountViewConfigure.userNameLabel
    private lazy var toDoInLabel = AccountViewConfigure.toDoInLabel
    private lazy var friendsLabel = AccountViewConfigure.friendsLabel
    private lazy var friendUnderlineView = AccountViewConfigure.friendUnderlineView
    private lazy var isSettingsMenuHidden = true
    private lazy var settingsBackgroundView = AccountViewConfigure.settingsBackgroundView
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
    private lazy var tapAddFriendRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFriendButtonTapped))
        
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
    
    private lazy var addFriendButton: UIButton = {
        let button = AccountViewConfigure.addFriendButton
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
    
    // Nested data types
    struct LayersConstants {
        static let settingsContentLeft: CGFloat = 20
        static let settingsContentRight: CGFloat = 5
        static let settingImageRight: CGFloat = 45
        static let scrollInsetBottom: CGFloat = 15
    }
    
    struct AnimationConstants {
        static var exitButtonAlpha: CGFloat = 1
        static var notificationButtonAlpha: CGFloat = 1
        static var backgroundAlpha: CGFloat = 0.2
    }
    
    // Initializers
    
    func setPresenter(presenter: AccountViewPresenter, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    // ViewController lifecycle methods
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
    
    // UI configure methods
    private func setupViews() {
        view.backgroundColor = .accentColor
        view.addSubviews(friendsTableView,
                         userBackView,
                         userNameLabel,
                         toDoInLabel,
                         friendsLabel,
                         addFriendButton,
                         friendUnderlineView,
                         settingsBackgroundView,
                         exitButton,
                         notificationButton,
                         addFriendView)
        userBackView.addSubviews(userImageView)
        
        settingsBackgroundView.addGestureRecognizer(tapRecognizer)
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
        
        notificationButton.pin
            .top(view.pin.safeArea.top)
            .end(12)
            .width(view.bounds.width / 2)
            .height(40)
            .marginTop(12)
        
        exitButton.pin
            .top(to: notificationButton.edge.bottom)
            .end(12)
            .width(view.bounds.width / 2)
            .height(40)
            .marginTop(12)
        
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
        navigationItem.rightBarButtonItem?.action = #selector(settingsButtonTapped)
    }
    
    private func configureViews() {
        if userBackView.layer.cornerRadius == 0 {
            userBackView.makeRound()
            AccountViewConfigure.getUserBackShadow(userBackView)
            
            userImageView.makeRound()
            AccountViewConfigure.getUserImageViewShadow(userImageView)
            
            
            [exitButton, notificationButton, addFriendButton].forEach{
                $0.layer.cornerRadius = 20
                AccountViewConfigure.getSettingButtonShadow($0)
                AccountViewConfigure.getSettingButtonGradiend($0)
            }
            
            AccountViewConfigure.getSettingsViewBlur(settingsBackgroundView)
            
            addFriendView.layer.cornerRadius = 20
            AccountViewConfigure.getBasicViewShadow(addFriendView)
        }
    }
    
    private func setupInsets() {
        friendsTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                      left: 0,
                                                                      bottom: LayersConstants.scrollInsetBottom,
                                                                      right: 0)
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
    
    // Actions methods
    
    @objc
    private func addFriendButtonTapped() {
        addViewAnimation()
    }
    
    @objc
    private func exitButtonTapped() {
        presenter?.showExitAlertController { [weak self] in
            self?.dropDownAnimation()
            self?.presenter?.exitButtonTapped()
        }
    }
    
    @objc
    private func notificationButtonTapped() {
        let image = presenter?.toggleNotifications()
        notificationButton.setImage(image, for: .normal)
    }
    
    @objc
    private func settingsButtonTapped() {
        dropDownAnimation()
    }
    
    @objc
    private func backViewTapped() {
        dropDownAnimation()
    }
    
    // Drop-down menu animation
    func dropDownAnimation() {
        var exitButtonAlpha: CGFloat = 1
        var notificationButtonAlpha: CGFloat = 1
        var backgroundAlpha: CGFloat = 1
        var duration = 0.3
        var delay = duration / 3
        
        if !isSettingsMenuHidden {
            exitButtonAlpha = 0
            notificationButtonAlpha = 0
            backgroundAlpha = 0
            duration = 0.1
            delay = 0
        }
        
        UIView.animate(withDuration: delay, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.settingsBackgroundView.alpha = backgroundAlpha
        }
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut]) { [weak self] in
            self?.notificationButton.alpha = notificationButtonAlpha
        }
        
        delay *= 2
        
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut]) { [weak self] in
            self?.exitButton.alpha = exitButtonAlpha
        }
        
        isSettingsMenuHidden.toggle()
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
}

extension AccountController: AccountView {
    func showErrorAlertController(with message: String) {
        presenter?.showErrorAlertController(with: message)
    }
    
    func showError(with error: String) {
        addFriendView.showError(with: error)
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }

    func setUp(with user: User) {
        userImageView.image = UIImage(named: user.image)
        userNameLabel.text = user.name
        toDoInLabel.text = user.email
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
