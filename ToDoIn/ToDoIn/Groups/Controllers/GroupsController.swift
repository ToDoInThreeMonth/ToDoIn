import UIKit
import PinLayout

class GroupsController: UIViewController {
        
    // MARK: - Properties
    
    private var presenter: GroupsViewPresenter?
    
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
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoadView()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
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
}

extension GroupsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.groupsCount ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as? GroupTableViewCell else {
            return UITableViewCell()
        }
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
        return tableView.bounds.height / 10
    }
}
