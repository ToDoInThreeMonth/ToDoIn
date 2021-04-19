import UIKit
import PinLayout

class GroupSettingsController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: GroupSettingsViewPresenter?
    
    private let group: Group
    
    private let groupTitle = UITextField()
    private let imageView = UIImageView()
    private let tableView = UITableView()
    private let addUserButton = UIButton(type: .system)
    
    private let cornerRadius: CGFloat = 15
    private let horizontalPadding: CGFloat = 40
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
        presenter = GroupSettingsPresenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        view.addSubviews(groupTitle, imageView, tableView, addUserButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setBackground()
        
        configureTitle()
        configureImageView()
        configureTableView()
        configureAddUserButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureShadows()
    }
    
    override func viewDidLayoutSubviews() {
        groupTitle.pin
            .top(view.pin.safeArea.top + 10)
            .horizontally(horizontalPadding)
            .height(30)
        
        imageView.pin
            .below(of: groupTitle)
            .marginTop(20)
            .horizontally(horizontalPadding)
            .height(180)
        
        addUserButton.pin
            .below(of: imageView)
            .right(0)
            .marginTop(20)
            .width(180)
            .height(40)
        
        tableView.pin
            .top(to: imageView.edge.bottom)
            .start(20)
            .end(to: addUserButton.edge.start)
            .bottom(view.pin.safeArea.bottom)
            .marginEnd(10)
            .marginTop(20)
    }
    
    func configureTitle() {
        groupTitle.text = group.name
        groupTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        groupTitle.textAlignment = .center
        groupTitle.textColor = .darkTextColor
        groupTitle.addTarget(self, action: #selector(groupTitleDidChange), for: .editingDidEnd)
    }
    
    func configureImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: group.image)
    }
    
    func configureTableView() {
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureAddUserButton() {
        addUserButton.setImage(UIImage(named: "addUser")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addUserButton.setTitle("Добавить участника", for: .normal)
        addUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addUserButton.setTitleColor(.darkTextColor, for: UIControl.State.normal)
        addUserButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        addUserButton.backgroundColor = .accentColor
        addUserButton.layer.cornerRadius = cornerRadius
        addUserButton.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
    }
    
    func configureShadows() {
        addUserButton.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        addUserButton.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
    
    @objc
    func groupTitleDidChange(sender: AnyObject) {
        // сохранение нового названия комнаты
        presenter?.groupTitleDidChange(with: groupTitle.text ?? nil)
    }
    
    @objc
    func addUserButtonTapped(sender: AnyObject) {
        // добавление нового участника
        presenter?.addUserButtonTapped()
    }

}


// MARK: - Extensions

extension GroupSettingsController: UITableViewDataSource {
    
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.users.count
    }
    
    // дизайн ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
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
        return tableView.bounds.height / 6
    }
}


