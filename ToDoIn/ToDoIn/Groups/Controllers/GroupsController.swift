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
    
    // MARK: - Handlers
    
    func setGroups(groups: [Group]) {
        self.groups = groups
        tableView.reloadData()
    }
    
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
        presenter.getGroups()
    }
    
    // MARK: Configures
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
    }
    
    func configureTableView() {
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}


// MARK: - Extensions

extension GroupsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
        cell.layer.cornerRadius = cell.frame.height / 2.6
        cell.setUp(group: groups[indexPath.row])
        return cell
    }
}

extension GroupsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showGroupController(group: groups[indexPath.row])
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 10
    }
}
