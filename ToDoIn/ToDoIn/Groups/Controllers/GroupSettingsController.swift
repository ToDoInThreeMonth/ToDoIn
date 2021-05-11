import UIKit
import PinLayout

class GroupSettingsController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupSettingsViewPresenter = GroupSettingsPresenter()
    
    private let group: Group
    
    private lazy var imageView: UIImageView = {
       let imageView = SettingsUIComponents.imageView
        imageView.image = UIImage(named: group.image)
        return imageView
    }()
    
    private lazy var groupBackView = SettingsUIComponents.groupBackView
    
    private lazy var groupTitle: UITextField = {
        let textField = SettingsUIComponents.groupTitle
        textField.text = group.name
        return textField
    }()
    
    private lazy var addUserButton: UIButton = {
        let button = SettingsUIComponents.addUserButton
        button.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
        return button
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
        setBackground()
        view.addSubviews(groupBackView, groupTitle, tableView, addUserButton)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInsets()
        configureAddButton()
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
        
        addUserButton.pin
            .below(of: groupTitle)
            .end(-10)
            .width(160)
            .height(40)
            .marginTop(20)
        
        tableView.pin
            .top(to: groupTitle.edge.bottom)
            .start(20)
            .end(to: addUserButton.edge.start)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    private func configureImageView() {
        if groupBackView.layer.cornerRadius == 0 {
            groupBackView.makeRound()
            SettingsUIComponents.getGroupBackViewShadow(groupBackView)
            
            imageView.makeRound()
            SettingsUIComponents.getImageViewShadow(imageView)
        }
    }
    
    private func configureAddButton() {
        if addUserButton.layer.cornerRadius == 0 {
            addUserButton.layer.cornerRadius = 15
            SettingsUIComponents.getAddButtonShadow(addUserButton)
        }
    }
    
    private func setupInsets() {
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: tableView.bounds.width - 8)
        addUserButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 25)
        addUserButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: addUserButton.frame.width - 45 - (addUserButton.imageView?.frame.width ?? 0))
        }
    
    // MARK: - Handlers
    @objc
    func groupTitleDidChange() {
        // сохранение нового названия комнаты
        presenter.groupTitleDidChange(with: groupTitle.text ?? nil)
    }
    
    @objc
    func addUserButtonTapped() {
        // добавление нового участника
        presenter.addUserButtonTapped()
    }
}


// MARK: - Extensions
extension GroupSettingsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        group.users.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(userName: group.users[indexPath.row].name, userImage: group.users[indexPath.row].image)
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


