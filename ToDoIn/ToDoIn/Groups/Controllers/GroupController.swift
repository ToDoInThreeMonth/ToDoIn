import UIKit
import PinLayout

class GroupController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupViewPresenter?
    
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
    
    override func loadView() {
        super.loadView()
        setBackground()
        title = group.name
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureBarButtonItems()
        navigationController?.configureBarButtonItems(screen: .groupsDetail, for: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all()
    }
        
    // MARK: Configures
    
    func configureTableView() {
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.alwaysBounceVertical = true
        
        view.addSubview(tableView)
    }
    
    func configureBarButtonItems() {
        configureSettingButton()
        configureAddingTaskButton()
      //  navigationItem.setRightBarButtonItems([settingsButton, addingTaskButton], animated: true)
    }
    
    func configureSettingButton() {
        settingsButton.image = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        settingsButton.target = self
        settingsButton.action = #selector(settingsButtonTapped)
    }
    
    func configureAddingTaskButton() {
        addingTaskButton.image = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        addingTaskButton.target = self
        addingTaskButton.action = #selector(addingTaskButtonTapped)
    }
    
    // MARK: - Handlers

    func setPresenter(presenter: GroupViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        presenter.setCoordinator(with: coordinator)
    }
    
    @objc
    func settingsButtonTapped() {
        presenter?.showSettingsGroupController(group: group)
    }
    
    @objc
    func addingTaskButtonTapped() {
        presenter?.showTaskCotroller(group: group, task: Task(), isChanging: false)
//        presenter?.showAddTask(group: group)
    }

}


// MARK: - Extensions

extension GroupController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            self.showErrorAlert()
            return 0
        }
        return presenter.getTasks(for: group.users[section], from: group).count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        guard let presenter = presenter else {
            self.showErrorAlert()
            return UITableViewCell()
        }
        cell.setUp(task: presenter.getTasks(for: group.users[indexPath.section], from: group)[indexPath.row])
        return cell
    }
    
    
    // количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        group.users.count
    }


    // заголовок секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.setUp(owner: group.users[section].name)
        return sectionHeaderView
    }
    
    // высота заголовка секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.bounds.height / 12
    }
}


extension GroupController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // открытие View с описанием задачи
        guard let presenter = presenter else {
            self.showErrorAlert()
            return
        }
        let currentTask = presenter.getTasks(for: group.users[indexPath.section], from: group)[indexPath.row]
        presenter.showTaskCotroller(group: group, task: currentTask, isChanging: true)
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 15
    }
}

