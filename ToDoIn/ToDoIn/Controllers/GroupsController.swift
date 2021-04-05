import UIKit
import PinLayout

class GroupsController: UIViewController {
    
    // MARK: - Properties
    
    var groups = Data.groups
    
    private let tableView = UITableView()
    
    
    // MARK: - Handlers
    
    override func loadView() {
        super.loadView()
        setBackground()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
    }
    
    func setBackground()  {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
    func configureTableView() {
        tableView.register(GroupCell.self, forCellReuseIdentifier: GroupCell.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell
//        cell.selectedBackgroundView = UIView()
//        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.layer.cornerRadius = cell.frame.height / 2.6
        cell.setUp(group: groups[indexPath.row])
        return cell
    }
}

extension GroupsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupController = GroupController(group: groups[indexPath.row])
        navigationController?.pushViewController(groupController, animated: true)
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 10
    }
}
