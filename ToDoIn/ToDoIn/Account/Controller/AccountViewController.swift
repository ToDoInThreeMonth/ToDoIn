import UIKit
import PinLayout

class AccountViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "nlo")
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    private lazy var userView: UIView = UIView()

    private lazy var userUpNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Неопознанный объект"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        return label
    }()
    
    private lazy var userDownNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь ToDoIn"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 0.5)
        return label
    }()
    
    private lazy var friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Друзья"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        return label
    }()
    
    private lazy var friendsDownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200 / 255, green: 14 / 255, blue: 14 / 255, alpha: 1)
        return view
    }()
    
    private lazy var searchTextField: CustomSearchTextField = {
        let textField = CustomSearchTextField()
        textField.addTarget(self, action: #selector(searchTFDidChanged), for: .editingChanged)
        return textField
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
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closedDoor")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Выйти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        button.tintColor = UIColor(red: 2 / 255, green: 44 / 255, blue: 114 / 255, alpha: 1)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "turnedNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Уведомления", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        button.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        button.tintColor = UIColor(red: 2 / 255, green: 44 / 255, blue: 114 / 255, alpha: 1)
        return button
    }()

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
        view.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        view.addSubviews(userView,
                         userUpNameLabel,
                         userDownNameLabel,
                         friendsLabel,
                         searchTextField,
                         friendsDownView,
                         friendsTableView,
                         exitButton,
                         notificationButton)
        userView.addSubviews(userImageView)
    }

    private func setupLayouts() {
        userView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
            .size(CGSize(width: 150, height: 150))
        userImageView.pin
            .all().margin(20)
        userUpNameLabel.pin
            .top(to: userView.edge.bottom)
            .hCenter()
            .marginTop(20)
            .sizeToFit()
        userDownNameLabel.pin
            .top(to: userUpNameLabel.edge.bottom)
            .hCenter()
            .sizeToFit()
        friendsLabel.pin
            .top(to: userDownNameLabel.edge.bottom)
            .start(40)
            .sizeToFit()
            .marginTop(35)
        friendsDownView.pin
            .top(to:  friendsLabel.edge.bottom)
            .marginTop(3)
            .hCenter(to: friendsLabel.edge.hCenter)
            .width(friendsLabel.bounds.width + 20)
            .height(3)
        searchTextField.pin
            .end(40)
            .start(to: friendsLabel.edge.end)
            .marginStart(30)
            .bottom(to: friendsDownView.edge.bottom)
            .top(to: friendsLabel.edge.top)
            .marginTop(-5)
        notificationButton.pin
            .top(to: friendsDownView.edge.bottom)
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
            .top(to: friendsDownView.edge.bottom)
            .start(20)
            .end(to: exitButton.edge.start)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    private func configureViews() {
       
        userView.makeRound()
        userView.backgroundColor = UIColor(red: 240 / 255, green: 238 / 255, blue: 239 / 255, alpha: 1)
        userView.addShadow(side: .bottomRight, type: .outside, alpha: 0.15)
        userView.addShadow(side: .bottomRight, type: .outside, color: .white, alpha: 1, offset: -10)
        userView.addShadow(side: .topLeft, type: .innearRadial, color: .white, power: 0.15, alpha: 1, offset: 10)
        userView.addShadow(side: .bottomRight, type: .innearRadial, power: 0.15, offset: 10)
        
        userImageView.makeRound()
        userImageView.addShadow(side: .topLeft, type: .innearRadial, power: 0.1, alpha: 0.3, offset: 10)
        userImageView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.1, alpha: 0.5, offset: 10)
        
        searchTextField.layer.cornerRadius = 20
        searchTextField.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        searchTextField.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
        
        [exitButton, notificationButton].forEach{
            $0.layer.cornerRadius = 15
            $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -2)
            $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
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
        let alertVC = UIAlertController(title: "Выход из аккаунта", message: "Вы действительно хотите выйти ?", preferredStyle: .alert)
        let agreeButton = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Да", style: .destructive) {[unowned self] _ in
            //  заглушка
        }
        alertVC.addAction(disagreeButton)
        alertVC.addAction(agreeButton)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc
    private func searchTFDidChanged() {
//        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
//            print("Friends not found")
//        }
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
