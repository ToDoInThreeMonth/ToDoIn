import UIKit
import PinLayout

protocol GroupSettingsView: class {
    func setPresenter(presenter: GroupSettingsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}

class GroupSettingsController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupSettingsViewPresenter?
    
    private let group: Group
    
    private lazy var imageView: UIImageView = {
       let imageView = SettingsUIComponents.imageView
        imageView.image = UIImage()
        return imageView
    }()
    
    private lazy var groupBackView = SettingsUIComponents.groupBackView
    
    private lazy var groupTitle: UITextField = {
        let textField = SettingsUIComponents.groupTitle
        textField.text = group.title
        return textField
    }()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setBackground()
        
        view.addSubviews(groupBackView, groupTitle, tableView)
        groupBackView.addSubviews(imageView)
        hideKeyboardWhenTappedAround()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayouts()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureImageView()
//        configureAddButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.didLoadView()

        setupInsets()
    }
    
    // MARK: - Configures
    
    private func configureLayouts() {
        groupBackView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
            .size(CGSize(width: 150, height: 150))
        
        imageView.pin
            .all().margin(20)
        
        groupTitle.pin
            .below(of: groupBackView, aligned: .center)
            .marginTop(20)
            .size(CGSize(width: 200, height: 40))
        
        tableView.pin
            .top(to: groupTitle.edge.bottom)
            .start(20)
            .end(20)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .roomSettings, for: self)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addUserButtonTapped)
    }
    
    private func configureImageView() {
        if groupBackView.layer.cornerRadius == 0 {
            groupBackView.makeRound()
            SettingsUIComponents.getGroupBackViewShadow(groupBackView)
            
            imageView.makeRound()
            SettingsUIComponents.getImageViewShadow(imageView)
        }
        
        // Подгружаем картинку из сети
        if group.image == "default" {
            imageView.image = UIImage(named: group.image)
        } else {
            presenter?.loadImage(url: group.image) { (image) in
                self.imageView.image = image
            }
        }
    }
    
    private func setupInsets() {
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: tableView.bounds.width - 8)
        }
    
    // MARK: - Handlers
    
    @objc
    func groupTitleDidChange() {
        // сохранение нового названия комнаты
        presenter?.groupTitleDidChange(with: groupTitle.text ?? nil)
    }
    
    @objc
    func addUserButtonTapped() {
        // добавление нового участника
        presenter?.addUserButtonTapped()
    }
}


// MARK: - Extensions

extension GroupSettingsController: GroupSettingsView {
    
    func setPresenter(presenter: GroupSettingsViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func reloadView() {
        tableView.reloadData()
    }
}

extension GroupSettingsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.usersCount ?? 0
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell, let user = presenter?.getUser(by: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.setUp(user: user)
        return cell
    }
}


extension GroupSettingsController: UITableViewDelegate {

    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // размер ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 6
    }
}


