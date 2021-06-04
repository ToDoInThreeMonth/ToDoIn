import UIKit
import PinLayout

protocol AddFriendViewOutput: AnyObject {
    func addNewFriend(_ mail: String)
    func dismissAddNewFriendView()
    func cleanFriendTextField()
    func cleanErrorLabel()
}

protocol AccountViewProtocol: AddFriendViewOutput {
    func showErrorAlertController(with message: String)
    func reloadView()
    func showError(with error: String)
    func setUp(with user: User)
}

final class AccountController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: AccountPresenterProtocol?
    
    private lazy var userImageView = CustomImageView()
    private lazy var userNameTextField = AccountUIComponents.userNameTextField
    private lazy var toDoInLabel = AccountUIComponents.toDoInLabel
    private lazy var friendsLabel = AccountUIComponents.friendsLabel
    private lazy var friendUnderlineView = AccountUIComponents.friendUnderlineView
    private lazy var settingsBackgroundView = AccountUIComponents.settingsBackgroundView
    private lazy var tapAddFriendRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFriendButtonTapped))
    
    private lazy var addFriendButton: UIButton = {
        let button = AccountUIComponents.addFriendButton
        button.addTarget(self, action: #selector(addFriendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var friendsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: String(describing: FriendTableViewCell.self))
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
        configureImageView()
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
                         userNameTextField,
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
        
        userNameTextField.pin
            .top(to: userImageView.edge.bottom)
            .hCenter()
            .marginTop(20)
            .size(CGSize(width: 300, height: 24))
        
        toDoInLabel.pin
            .top(to: userNameTextField.edge.bottom)
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
        userNameTextField.addTarget(self, action: #selector(userNameDidChange), for: .editingDidEnd)
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
    
    private func configureImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
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
    
    @objc
    private func imageViewTapped() {
        ImagePickerManager().pickImage(self) { [weak self] image in
            self?.presenter?.imageIsChanged(with: image)
            self?.userImageView.setImage(with: image)
            self?.userImageView.contentMode = .scaleAspectFill
        }
    }
    
    @objc
    private func userNameDidChange() {
        guard let newName = userNameTextField.text else { return }
        presenter?.userNameDidChange(with: newName)
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


// MARK: - Extensions

extension AccountController: AccountViewProtocol {

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
        userNameTextField.text = user.name
        toDoInLabel.text = user.email
        if user.image != "default" {
            presenter?.loadImage(url: user.image) { (image) in
                self.userImageView.setImage(with: image)
            }
        }
    }
    
    func addNewFriend(_ email: String) {
        presenter?.addNewFriend(email)
    }
    
    func dismissAddNewFriendView() {
        addViewAnimation()
    }

}


extension AccountController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getAllFriends().count ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendTableViewCell.self), for: indexPath) as? FriendTableViewCell, let user = presenter?.getFriend(by: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.friend = user
        let friendImage = user.image
        presenter?.loadImage(url: friendImage) { (image) in
            cell.setFriendAvatar(with: image)
        }
        return cell
    }
}


extension AccountController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let friend = presenter?.getFriend(by: indexPath.row) else { return }
            presenter?.deleteTapped(for: friend)
        }
    }
}

