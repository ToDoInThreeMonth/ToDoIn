import UIKit

protocol AddUserToGroupView: class {
    func setPresenter(_ presenter: AddUserToGroupViewPresenter, coordinator: GroupsChildCoordinator)

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
    
    private let addButton = CustomButton(with: "Добавить")
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoadView()

        setBackground()
        
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
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
    
    // MARK: - Handlers
    
    @objc
    func buttonTapped() {
        let selectedIndexes = friendsTableView.indexPathsForSelectedRows ?? []
        if selectedIndexes.count != 0 {
            presenter?.addButtonTapped(selectedUsers: selectedIndexes)
            dismiss(animated: true, completion: nil)
        }
    }

}

extension AddUserToGroupController: AddUserToGroupView {
    func setPresenter(_ presenter: AddUserToGroupViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func reloadView() {
        friendsTableView.reloadData()
    }
}

extension AddUserToGroupController: FriendsTableViewOutput {
    
    func getPhoto(by url: String, completion: @escaping (UIImage) -> Void) {
        presenter?.loadImage(url: url) { (image) in
            completion(image)
        }
    }
    
    func showErrorAlertController(with message: String) {
        presenter?.showErrorAlertController(with: message)
    }
    
    func getFriend(by index: Int) -> User? {
        presenter?.getFriend(by: index)
    }
    
    func getAllFriends() -> [User]? {
        presenter?.getAllFriends()
    }
}
