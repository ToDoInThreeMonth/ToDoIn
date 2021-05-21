import UIKit
import PinLayout

protocol GroupSettingsView: AnyObject {
    func setPresenter(presenter: GroupSettingsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}

final class GroupSettingsController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupSettingsViewPresenter?
    
    private let group: Group
    
    private let imageView = CustomImageView()
    private let groupTitle = UITextField()
    private let tableView = UITableView()
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoadView()
        setupNavigationItem()
        setBackground()
        
        view.addSubviews(imageView, groupTitle, tableView)
        hideKeyboardWhenTappedAround()
        
        configureGroupTitle()
        configureImageView()
        configureTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayouts()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        navigationController?.configureBarButtonItems(screen: .groupSettings, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addUserButtonTapped)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: String(describing: FriendTableViewCell.self))
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
    private func groupTitleDidChange() {
        // сохранение нового названия комнаты
        presenter?.groupTitleDidChange(with: groupTitle.text ?? nil)
    }
    
    @objc
    private func addUserButtonTapped() {
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

extension GroupSettingsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getAllUsers().count ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendTableViewCell.self), for: indexPath) as? FriendTableViewCell, let user = presenter?.getUser(by: indexPath.row) else {
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


extension GroupSettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = presenter?.getUser(by: indexPath.row) else { return }
            presenter?.deleteTapped(for: user, in: group)
        }
    }
}
