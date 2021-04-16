import UIKit
import PinLayout

class GroupsController: UIViewController, CoordinatorOutput {
    
    // MARK: - Properties
    
    weak var coordinator: MainChildCoordinator?
    
    private var groups = Groups()
    
    private let tableView = UITableView()
    
    
    // MARK: - Handlers
    
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
        return groups.groups.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
        cell.layer.cornerRadius = cell.frame.height / 2.6
        cell.setUp(group: groups.groups[indexPath.row])
        return cell
    }
}

extension GroupsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showGroupController(group: groups.groups[indexPath.row])
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 10
    }
}
