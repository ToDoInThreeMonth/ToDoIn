import UIKit
import PinLayout

protocol GroupSettingsView: class {
    func setPresenter(presenter: GroupSettingsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}

class GroupSettingsController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupSettingsViewPresenter?
    
    private let group: Group
    
    private let imageView = CustomImageView()

    private let groupTitle = UITextField()
        
    private lazy var usersTVDelegate = FriendsTVDelegate()
    private lazy var usersTVDataSource = FriendsTVDataSource(controller: self)
    private lazy var tableView: UITableView = {
        let tableView = FriendsTableView(frame: .zero, style: .plain)
        tableView.dataSource = usersTVDataSource
        tableView.delegate = usersTVDelegate
        return tableView
    }()
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setBackground()
        
        view.addSubviews(imageView, groupTitle, tableView)
        hideKeyboardWhenTappedAround()
        
        configureGroupTitle()
        configureImageView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayouts()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.didLoadView()

        setupInsets()
    }
    
    // MARK: - Configures
    
    private func configureLayouts() {
        imageView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
        
        groupTitle.pin
            .below(of: imageView, aligned: .center)
            .marginTop(20)
            .size(CGSize(width: 200, height: 40))
        
        tableView.pin
            .top(to: groupTitle.edge.bottom)
            .start(20)
            .end(20)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .roomSettings, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addUserButtonTapped)
    }
    
    private func configureImageView() {
        // Подгружаем картинку из сети
        if group.image != "default" {
            presenter?.loadImage(url: group.image) { (image) in
                self.imageView.setImage(with: image)
            }
        }
    }

    private func configureGroupTitle() {
        groupTitle.text = group.title
        groupTitle.font = UIFont.systemFont(ofSize: 20)
        groupTitle.textColor = .darkTextColor
        groupTitle.textAlignment = .center
    }
    
    
    private func setupInsets() {
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: tableView.bounds.width - 8)
        }
    
    // MARK: - Handlers
    
    @objc
    func groupTitleDidChange() {
        // сохранение нового названия комнаты
        presenter?.groupTitleDidChange(with: groupTitle.text ?? nil)
    }
    
    @objc
    func addUserButtonTapped() {
        // добавление нового участника
        presenter?.addUserButtonTapped()
    }
}


// MARK: - Extensions

extension GroupSettingsController: GroupSettingsView {
    
    func setPresenter(presenter: GroupSettingsViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func reloadView() {
        tableView.reloadData()
    }
}

extension GroupSettingsController: FriendsTableViewOutput {
    func showErrorAlertController(with message: String) {
        
    }
    
    func getFriend(by index: Int) -> User? {
        presenter?.getUser(by: index)
    }
    
    func getAllFriends() -> [User]? {
        presenter?.getAllUsers()
    }
    
    func getPhoto(by url: String, completion: @escaping (UIImage) -> Void) {
        presenter?.loadImage(url: url) { (image) in
            completion(image)
        }
    }
    
    
}

extension GroupSettingsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.usersCount ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell, let user = presenter?.getUser(by: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.setUp(user: user)
        return cell
    }
}


extension GroupSettingsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 6
    }
}


