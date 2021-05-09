import UIKit

protocol AddGroupView {
    func setPresenter(presenter: AddGroupViewPresenter)
    
    func transitionToMain()
}

class AddGroupController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var presenter: AddGroupViewPresenter?
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let imageViewLabel = UILabel()
    private let usersLabel = UILabel()
    private let addButton = CustomButton(with: "Добавить")

    private var imageView = CustomImageView()
    
    private lazy var friendsTVDelegate = FriendsTVDelegate()
    private lazy var friendsTVDataSource = FriendsTVDataSource(controller: self)
    private lazy var friendsTableView: UITableView = {
        let tableView = FriendsTableView(frame: .zero, style: .plain)
        tableView.allowsMultipleSelection = true
        tableView.dataSource = friendsTVDataSource
        tableView.delegate = friendsTVDelegate
        return tableView
    }()
    
    struct LayersConstants {
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let textFieldCornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
    }
    
    // MARK: - Configures
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        view.addSubviews(titleLabel, nameLabel, nameTextField, imageViewLabel, usersLabel, addButton, imageView, friendsTableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.didLoadView()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureLabels()
        configureNameTextField()
        configureAddButton()
        configureImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
        configureShadowsAndCornerRadius()
    }
    
    func configureLayouts() {
        titleLabel.pin
            .top(15).hCenter()
            .sizeToFit()
        
        nameLabel.pin
            .below(of: titleLabel, aligned: .center)
            .marginTop(25)
            .sizeToFit()
        
        nameTextField.pin
            .below(of: nameLabel)
            .marginTop(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(35)
        
        imageViewLabel.pin
            .below(of: nameTextField, aligned: .center)
            .marginTop(35)
            .sizeToFit()
        
        imageView.pin
            .below(of: imageViewLabel, aligned: .center)
            .marginTop(15)
        
        usersLabel.pin
            .below(of: imageView, aligned: .center)
            .marginTop(35)
            .sizeToFit()
        
        addButton.pin
            .bottom(view.pin.safeArea.bottom + 20)
            .hCenter()
        
        friendsTableView.pin
            .below(of: usersLabel)
            .above(of: addButton)
            .marginTop(10)
            .horizontally(LayersConstants.horizontalPadding)
    }
    
    func configureNameTextField() {
        nameTextField.placeholder = "Название комнаты"
        nameTextField.textColor = .darkTextColor
        nameTextField.backgroundColor = .white
    }
    
    func configureLabels() {
        titleLabel.text = "Создать новую комнату"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.text = "Название"
        imageViewLabel.text = "Аватарка"
        usersLabel.text = "Выберите участников комнаты:"
        [titleLabel, nameLabel, imageViewLabel, usersLabel].forEach { $0.textColor = .darkTextColor }
        
    }
    
    func configureAddButton() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func configureImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    func configureShadowsAndCornerRadius() {
        nameTextField.layer.cornerRadius = LayersConstants.cornerRadius
        nameTextField.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        nameTextField.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
    
    // MARK: - Handlers
    
    @objc
    func imageViewTapped() {
        ImagePickerManager().pickImage(self) { image in
            self.imageView.setImage(with: image)
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    @objc
    func addButtonTapped() {
        let selectedIndexes = friendsTableView.indexPathsForSelectedRows
        if let groupName = nameTextField.text, !groupName.isEmpty {
            presenter?.addButtonTapped(title: groupName, selectedUsers: selectedIndexes ?? [], photo: imageView.getImage())
            transitionToMain()
        }
    }
    
    func transitionToMain() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension AddGroupController: FriendsTableViewOutput {
    
    func getPhoto(by url: String, completion: @escaping (UIImage) -> Void) {
        presenter?.loadImage(url: url) { (image) in
            completion(image)
        }
    }
    
    func getFriend(by index: Int) -> User? {
        presenter?.getFriend(by: index)
    }
    
    func getAllFriends() -> [User]? {
        presenter?.getAllFriends()
    }
    
    
    func reloadView() {
        friendsTableView.reloadData()
    }
    
    func showErrorAlertController(with message: String) {
        print(#function)
    }
}

extension AddGroupController: AddGroupView {
    func setPresenter(presenter: AddGroupViewPresenter) {
        self.presenter = presenter
    }
}
