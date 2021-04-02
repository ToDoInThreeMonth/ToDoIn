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
    
    private lazy var userDownView: UIView = UIView()
    private lazy var userUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240 / 255, green: 238 / 255, blue: 239 / 255, alpha: 1)
        return view
    }()

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
    
    private lazy var searchTextField: UITextField = CustomSearchTextField()
    
    private lazy var friendsTableView: UITableView = {
        let tableView = UITableView()
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
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 25)
        button.setTitle("Выйти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        button.tintColor = UIColor(red: 2 / 255, green: 44 / 255, blue: 114 / 255, alpha: 1)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "OnNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 25)
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
        setupSublayers()
        setupInsets()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        view.addSubviews(userDownView,
                         userUpNameLabel,
                         userDownNameLabel,
                         friendsLabel,
                         searchTextField,
                         friendsDownView,
                         friendsTableView,
                         exitButton,
                         notificationButton)
        userDownView.addSubviews(userUpView, userImageView)
        
    }

    private func setupLayouts() {
        userDownView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
            .size(CGSize(width: 150, height: 150))
        userUpView.pin.all()
        userImageView.pin
            .all().margin(20)
        userUpNameLabel.pin
            .top(to: userDownView.edge.bottom)
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
    
    private func setupSublayers() {
       
        userUpView.makeRound()
        userDownView.addOneMoreShadow(color: .black, alpha: 0.15, x: 10, y: 10, blur: 10, cornerRadius: userUpView.layer.cornerRadius)
        userDownView.addOneMoreShadow(color: .white, alpha: 0.5, x: -10, y: -10, blur: 10, cornerRadius: userUpView.layer.cornerRadius)
        userUpView.addInnerShadow(color1: UIColor.white, power: 0.1, alpha: 1, isRadial: true, offset: CGSize(width: 15, height: 15))
        userUpView.addInnerShadow(power: 0.1, alpha: 0.1, isRadial: true, offset: CGSize(width: -15, height: -15))
        
        userImageView.makeRound()
        userImageView.addInnerShadow(power: 0.09, alpha: 0.3, isRadial: true, offset: CGSize(width: 10, height: 10))
        userImageView.addInnerShadow(color1: .white, power: 0.1, alpha: 0.5, isRadial: true, offset: CGSize(width: -10, height: -10))
        
        searchTextField.layer.cornerRadius = 20
        searchTextField.insertBackLayer()
        searchTextField.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
        searchTextField.addOneMoreShadow(color: .black, alpha: 0.15, x: -1, y: 1, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
        
        exitButton.layer.cornerRadius = 15
        exitButton.insertBackLayer()
        exitButton.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -2, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
        exitButton.addOneMoreShadow(color: .black, alpha: 0.12, x: -1, y: 2, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
        
        notificationButton.layer.cornerRadius = 15
        notificationButton.insertBackLayer()
        notificationButton.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -2, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
        notificationButton.addOneMoreShadow(color: .black, alpha: 0.12, x: -1, y: 2, blur: 1, cornerRadius: searchTextField.layer.cornerRadius)
    }
    
    private func setupInsets() {
//        friendsTableView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        friendsTableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: friendsTableView.bounds.width - 8)
    }
    
    @objc
    private func exitButtonTapped() {
        let alertVC = UIAlertController(title: "Выход из аккаунта", message: "Вы действительно хотите выйти ?", preferredStyle: .alert)
        let agreeButton = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Да", style: .cancel) {[unowned self] _ in
            //  заглушка
        }
        alertVC.addAction(agreeButton)
        alertVC.addAction(disagreeButton)
        present(alertVC, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendModel.friends.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as! AccountTableViewCell
        cell.friend = FriendModel.friends[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        scrollView.coordinateSpace.bounds
    }
}

extension AccountViewController: UITableViewDelegate {

}


private final class ActionButton: UIButton {
    init(image: UIImage) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
