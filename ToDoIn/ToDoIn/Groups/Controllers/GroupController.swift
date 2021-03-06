import UIKit
import PinLayout

protocol GroupViewProtocol: AnyObject {
    func setPresenter(presenter: GroupPresenterProtocol, coordinator: GroupsChildCoordinator)
    func reloadView()
}

final class GroupController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupPresenterProtocol?
    
    private var group: Group
    
    private let tableView = UITableView()
    private let settingsButton = UIBarButtonItem()
    private let addingTaskButton = UIBarButtonItem()
    
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func loadView() {
        super.loadView()
        setBackground()
        title = group.title
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoadView(by: group.id)
        configureTableView()
        setupNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
        
    // MARK: Configures
    
    private func setupNavigationItem() {
        let button1 = UIButton(type: .system)
        button1.addTarget(self, action: #selector(addingTaskButtonTapped), for: .touchUpInside)
        let button2 = UIButton(type: .system)
        button2.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        navigationController?.configureBarButtonItems(screen: .groupDetail, for: self, rightButton: button1, leftButton: button2)
        title = group.title
    }
    
    private func configureTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.alwaysBounceVertical = true
        
        view.addSubview(tableView)
    }
    
    // MARK: - Handlers
    
    @objc
    private func settingsButtonTapped() {
        presenter?.showSettingsGroupController()
    }
    
    @objc
    private func addingTaskButtonTapped() {
        presenter?.showTaskCotroller(task: Task(), isChanging: false)
    }

}


// MARK: - Extensions

extension GroupController: GroupViewProtocol {
    
    func setPresenter(presenter: GroupPresenterProtocol, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        presenter.setCoordinator(with: coordinator)
    }

    func reloadView() {
        tableView.reloadData()
    }
}

extension GroupController: UITableViewDataSource {
    
    // ???????????????????? ??????????
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            self.showErrorAlert()
            return 0
        }
        let userId = presenter.getUser(by: section).id
        if !userId.isEmpty {
            return presenter.getTasks(for: userId).count
        }
        return 0
    }
    
    // ???????????? ????????????
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        guard let presenter = presenter else {
            self.showErrorAlert()
            return UITableViewCell()
        }
        let userId = presenter.getUser(by: indexPath.section).id
        if !userId.isEmpty {
            cell.setUp(task: presenter.getTasks(for: userId)[indexPath.row])
        }
        return cell
    }
    
    // ???????????????????? ????????????
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.usersCount ?? 0
    }

    // ?????????????????? ????????????
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        let owner = presenter?.getUser(by: section).name ?? ""
        sectionHeaderView.setUp(owner: owner)
        return sectionHeaderView
    }
    
    // ???????????? ?????????????????? ????????????
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.bounds.height / 12
    }
}


extension GroupController: UITableViewDelegate {

    // ?????????????? ???? ????????????
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ???????????????? View ?? ?????????????????? ????????????
        guard let presenter = presenter else {
            self.showErrorAlert()
            return
        }
        let userId = presenter.getUser(by: indexPath.section).id
        if !userId.isEmpty {
            let currentTask = presenter.getTasks(for: userId)[indexPath.row]
            presenter.showTaskCotroller(task: currentTask, isChanging: true)
        }
    }
    
    // ???????????? ????????????
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 15
    }
}

