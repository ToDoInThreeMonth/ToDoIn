import UIKit
import PinLayout

protocol GroupsView: AnyObject {
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
    func loadData()
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)
}

final class GroupsController: UIViewController {
        
    // MARK: - Properties
    
    private var presenter: GroupsViewPresenter?
    
    private let tableView = UITableView()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        setupNavigationItem()
        setBackground()
        
        configureTableView()
        
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotification(notification:)), name: Notification.Name("AuthChanged"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
    }
    
    // MARK: Configures
    
    private func configureTableView() {
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .groups, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addGroupButtonTapped)
    }
    
    // MARK: - Handlers
    
    @objc
    private func addGroupButtonTapped() {
        presenter?.addGroupButtonTapped()
    }
    
    @objc
    private func receivedNotification(notification: Notification){
        loadData()
    }
    
    @objc
    private func didPullToRefresh() {
        loadData()
    }
    
}


// MARK: - Extensions

extension GroupsController: GroupsView {
    
    func loadData() {
        presenter?.loadData()
    }
    
    func reloadView() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        presenter?.loadImage(url: url) { (image) in
            completion(image)
        }
    }
}

extension GroupsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.groupsCount ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as? GroupTableViewCell else {
            return UITableViewCell()
        }
        cell.setupController(with: self)
        cell.setUp(group: presenter?.getGroup(at: indexPath.row) ?? Group())
        return cell
    }
}

extension GroupsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else {
            self.showErrorAlert()
            return
        }
        presenter.showGroupController(group: presenter.getGroup(at: indexPath.row))
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 10
    }
    
    // удаление комнаты
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let deletedGroup = presenter?.getGroup(at: indexPath.row) else { return }
            presenter?.deleteTapped(for: deletedGroup, at: indexPath.row)
        }
    }
}
