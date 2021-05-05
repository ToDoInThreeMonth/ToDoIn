import UIKit
import PinLayout

class GroupsController: UIViewController, GroupsView {
        
    // MARK: - Properties
    
    private var presenter: GroupsViewPresenter?
    
    private var groups = [Group]()
    
    private let tableView = UITableView()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setBackground()
        presenter?.getGroups()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationController?.configureBarButtonItems(screen: .groups, for: self)
        navigationItem.rightBarButtonItem?.action = #selector(addGroupTapped)
        navigationItem.rightBarButtonItem?.target = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
        
    }
    
    // MARK: Configures
    
    func configureTableView() {
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Handlers
    
    func setGroups(groups: [Group]) {
        self.groups = groups
        tableView.reloadData()
    }
    
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    @objc func addGroupTapped() {
        presenter?.showAddGroupController()
    }
}


// MARK: - Extensions

extension GroupsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as? GroupTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(group: groups[indexPath.row])
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
        presenter.showGroupController(group: groups[indexPath.row])
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 10
    }
}
