import UIKit
import PinLayout

class GroupController: UIViewController, GroupView {
    
    // MARK: - Properties
    
    lazy var presenter = GroupPresenter(groupView: self)
    weak var coordinator: MainChildCoordinator?
    
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

    
    // MARK: - Handlers
    
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
    }
    
    override func viewDidLayoutSubviews() {
        tableView.pin.all()
    }
    
    
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
        navigationItem.setRightBarButtonItems([settingsButton, addingTaskButton], animated: true)
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
    
    @objc
    func settingsButtonTapped(sender: UIBarButtonItem) {
        coordinator?.showSettingsGroupController(group: group)
    }
    
    @objc
    func addingTaskButtonTapped(sender: UIBarButtonItem) {
        coordinator?.showAddTask(group: group)
    }

}


// MARK: - Extensions

extension GroupController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.users[section].tasks.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.setUp(task: group.users[indexPath.section].tasks[indexPath.row])
        return cell
    }
    
    
    // количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return group.users.count
    }


    // заголовок секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.setUp(owner: group.users[section].name)
        return sectionHeaderView
    }
    
    // высота заголовка секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.height / 12
    }
}


extension GroupController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // открытие View с описание задачи
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 15
    }
}

