import UIKit
import PinLayout

class MainController: UIViewController, MainView {
    
    private var presenter: MainViewPresenter?
    
    private var data = [Section]()
    
    private lazy var offlineTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        tableView.separatorStyle = .none
        tableView.register(MainOfflineTableViewCell.self, forCellReuseIdentifier: String(describing: MainOfflineTableViewCell.self))
        tableView.register(MainOfflineHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainOfflineHeaderView.self))
        return tableView
    }()
    
    private lazy var authLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.darkTextColor.withAlphaComponent(0.7)
        label.text = "Войдите в аккаунт, чтобы увидеть задачи из совместных комнат"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Авторизоваться", for: .normal)
        button.tintColor = .darkTextColor
        button.backgroundColor = .accentColor
        return button
    }()
    
    private lazy var translucentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        button.target = self
        button.action = #selector(addingSectionButtonTapped)
        return button
    }()
    
    private let dolphinImageView = UIImageView(image: UIImage(named: "dolphinBlur"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupViews()
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupShadows()
    }
    
    private func setupViews() {
        view.addSubviews(dolphinImageView, offlineTableView, authLabel, authButton, translucentView)
    }
    
    private func setupLayouts() {
        dolphinImageView.pin
            .size(CGSize(width: 150, height: 100))
            .hCenter()
            .bottom(view.pin.safeArea.bottom)
            .marginBottom(20)
        
        translucentView.pin
            .height(200)
            .horizontally(15)
            .bottom(-15)
        
        authButton.pin
            .bottom(to: translucentView.edge.top)
            .marginBottom(15)
            .hCenter()
            .size(CGSize(width: 230, height: 40))
        
        authLabel.pin
            .bottom(to: authButton.edge.top)
            .marginBottom(15)
            .horizontally(50)
            .sizeToFit(.width)
        
        offlineTableView.pin
            .top(view.pin.safeArea.top)
            .bottom(to: authLabel.edge.top)
            .horizontally(32)
            .marginBottom(20)
            .marginTop(15)
    }
    
    private func setupShadows() {
        if authButton.layer.cornerRadius == 0 {
            authButton.layer.cornerRadius = 20
            authButton.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
            authButton.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
            authButton.addLinearGradiend()
        }
    }
    
    @objc
    func addingSectionButtonTapped() {
        presenter?.showAddSection()
    }
    
    func setPresenter(presenter: MainViewPresenter, coordinator: MainChildCoordinator) {
        self.presenter = presenter
        presenter.setCoordinator(with: coordinator)
        data = presenter.getSections()
    }
    
    func setSections(sections: [Section]) {
        
    }
    
    func addTaskButtonTapped(section: Section) {
        presenter?.showTaskCotroller(section: section, post: Post(), isChanging: false)
    }
}

extension MainController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
        guard let saveHeaderView = headerView else { return nil }
        saveHeaderView.setSectionLabel(with: data[section])
        saveHeaderView.mainViewController = self
        return saveHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainOfflineTableViewCell.self), for: indexPath) as? MainOfflineTableViewCell
        guard let safeCell = cell else { return UITableViewCell() }
        safeCell.textLabel?.text = data[indexPath.section].posts[indexPath.row].title
        safeCell.textLabel?.textColor = .darkTextColor
        return safeCell
    }
}

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? MainOfflineTableViewCell else { return }
//        cell.cellDidTapped()
        presenter?.showTaskCotroller(section: data[indexPath.section], post: data[indexPath.section].posts[indexPath.row], isChanging: true)
    }
}

