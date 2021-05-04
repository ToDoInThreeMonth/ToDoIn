import UIKit
import PinLayout

class AccountViewController: UIViewController, FriendsTableViewOutput {
    // Stored properties
    private var presenter: AccountViewPresenter
    private(set) lazy var users: [FriendModelProtocol] = presenter.getAllFriends()
    
    // Lazy stored properties
    private lazy var isSettingsMenuHidden = true
    private lazy var settingsBackgroundView = AccountViewConfigure.settingsBackgroundView
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
    
    private lazy var friendsTVDelegate = FriendsTVDelegate()
    private lazy var friendsTVDataSource = FriendsTVDataSource(controller: self)
    private lazy var friendsTableView: UITableView = {
        let tableView = FriendsTableView(frame: .zero, style: .plain)
        tableView.dataSource = friendsTVDataSource
        tableView.delegate = friendsTVDelegate
        return tableView
    }()
    
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
    init(presenter: AccountViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
        setupNavigationItem()
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
    
    // UI configure methods
    private func setupViews() {
        view.backgroundColor = .darkAccentColor
        view.addSubviews(friendsTableView,
                         userBackView,
                         userNameLabel,
                         toDoInLabel,
                         friendsLabel,
                         searchTextField,
                         friendUnderlineView,
                         settingsBackgroundView,
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
        settingsBackgroundView.pin
            .all()
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .account, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(settingsButtonTapped)
    }
    
    private func configureViews() {
        userBackView.makeRound()
        AccountViewConfigure.getUserBackShadow(userBackView)
        
        userImageView.makeRound()
        AccountViewConfigure.getUserImageViewShadow(userImageView)
        
        searchTextField.layer.cornerRadius = 20
        AccountViewConfigure.getSearchTFShadow(searchTextField)
        
        [exitButton, notificationButton].forEach{
            $0.layer.cornerRadius = 20
            AccountViewConfigure.getSettingButtonShadow($0)
            AccountViewConfigure.getSettingButtonGradiend($0)
        }
        
        AccountViewConfigure.getSettingsViewBlur(settingsBackgroundView)
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
    private func exitButtonTapped() {
        presenter.showExitAlertController { [weak self] in
            self?.dropDownAnimation()
        }
    }
    
    @objc
    private func notificationButtonTapped() {
        let image = presenter.toggleNotifications()
        notificationButton.setImage(image, for: .normal)
    }
    
    @objc
    private func searchTFDidChanged() {
        guard let text = searchTextField.text else { return }
        
        if text == "" {
            users = presenter.getAllFriends()
        } else {
            users = presenter.getFriends(from: text)
        }
        
        friendsTableView.reloadData()
    }
    
    @objc
    private func settingsButtonTapped() {
        dropDownAnimation()
    }
    
    // Another methods
    func showErrorAlertController(with message: String) {
        presenter.showErrorAlertController(with: message)
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
}
