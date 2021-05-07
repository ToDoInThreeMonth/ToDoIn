import UIKit

protocol AddUserToGroupView: class {
    func setPresenter(_ presenter: AddUserToGroupViewPresenter)
    
    func reloadView()
}

class AddUserToGroupController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var friendsTVDelegate = FriendsTVDelegate()
    private lazy var friendsTVDataSource = FriendsTVDataSource(controller: self)
    private lazy var friendsTableView: UITableView = {
        let tableView = FriendsTableView(frame: .zero, style: .plain)
        tableView.dataSource = friendsTVDataSource
        tableView.delegate = friendsTVDelegate
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    struct LayersConstants {
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
    }
    
    private var presenter: AddUserToGroupViewPresenter?
    
    private let chooseUserTitle: UILabel = {
        let label = UILabel()
        label.text = "Выберите участников группы:"
        label.textColor = .darkTextColor
        label.textAlignment = .center
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.darkTextColor, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - LayersConstants.horizontalPadding * 2, height: LayersConstants.buttonHeight)
        gradientLayer.cornerRadius = LayersConstants.cornerRadius
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.accentColor.cgColor]
        button.layer.insertSublayer(gradientLayer, at: 0)
        return button
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
            
        setBackground()
        
        view.addSubviews(friendsTableView, chooseUserTitle, addButton)
    }
    
    override func viewDidLayoutSubviews() {
        chooseUserTitle.pin
            .top(20)
            .hCenter()
            .sizeToFit()
        
        addButton.pin
            .bottom(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.buttonHeight)
        
        friendsTableView.pin
            .top(to: chooseUserTitle.edge.bottom)
            .bottom(to: addButton.edge.top)
            .hCenter()
            .marginTop(20)
            .width(view.bounds.width - 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.didLoadView()
    }
    
    // MARK: - Handlers
    
    @objc
    func buttonTapped() {
        print(#function)
    }

}

extension AddUserToGroupController: AddUserToGroupView {
    func setPresenter(_ presenter: AddUserToGroupViewPresenter) {
        self.presenter = presenter
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }
}

extension AddUserToGroupController: FriendsTableViewOutput {
    func showErrorAlertController(with message: String) {
        
    }
    
    func setUp(with user: User) {
        
    }
    
    func getFriend(by index: Int) -> User? {
        presenter?.getFriend(by: index)
    }
    
    func getAllFriends() -> [User]? {
        presenter?.getAllFriends()
    }
}
