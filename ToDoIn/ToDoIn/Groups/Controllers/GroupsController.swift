import UIKit
import PinLayout

class GroupsController: UIViewController {
        
    // MARK: - Properties
    
    private var presenter: GroupsViewPresenter?
    
    private let tableView = UITableView()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setBackground()
        
        configureTableView()
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin.all().marginTop(view.pin.safeArea.top + 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.didLoadView()
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
}
