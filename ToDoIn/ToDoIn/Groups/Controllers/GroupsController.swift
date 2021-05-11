import UIKit
import PinLayout

protocol GroupsView: class {
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)
}

class GroupsController: UIViewController {
        
    // MARK: - Properties
    
    private var presenter: GroupsViewPresenter?
    
    private let tableView = UITableView()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.didLoadView()
        
        setupNavigationItem()
        setBackground()
        
        configureTableView()
        
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReceivedNotification(notification:)), name: Notification.Name("AuthChanged"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Configures
    
    func configureTableView() {
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .rooms, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addGroupButtonTapped)
    }
    
    // MARK: - Handlers
    
    @objc
    func addGroupButtonTapped() {
        presenter?.addGroupButtonTapped()
    }
    
    @objc
    func ReceivedNotification(notification: Notification){
        presenter?.didLoadView()
    }
    
}


// MARK: - Extensions

extension GroupsController: GroupsView {
    
    func reloadView() {
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            guard let deletedGroup = presenter?.getGroup(at: indexPath.row) else { return }
            presenter?.deleteTapped(for: deletedGroup, at: indexPath.row) { (error) in
                if error == nil {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            tableView.endUpdates()
        }
    }
}
