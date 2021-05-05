import UIKit

protocol FriendSearchView: class {
    func setPresenter(presenter: FriendSearchViewPresenter, coordinator: AccountChildCoordinator)
    
    func setUpResultLabel(user: User)
}

class FriendSearchController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: FriendSearchViewPresenter?
        
    private var searchTextField = UITextField()
    
    private var resultLabel = UILabel()
    
    private var addButton = UIButton()
    
    // MARK: - Init

    
    // MARK: - Configures

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureSearchTextField()
        configureAddButton()
        view.addSubviews(searchTextField, resultLabel, addButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchTextField.pin
            .top(50).hCenter()
            .size(CGSize(width: 150, height: 30))
        
        resultLabel.pin
            .below(of: searchTextField, aligned: .center)
            .size(CGSize(width: 150, height: 50))
        
        addButton.pin
            .below(of: resultLabel, aligned: .center)
            .size(CGSize(width: 150, height: 50))
    }
    
    func configureSearchTextField() {
        searchTextField.backgroundColor = .gray
        searchTextField.placeholder = "Пользователь"
        searchTextField.addTarget(self, action: #selector(searchFieldDidChange), for: .editingDidEnd)
    }
    
    func configureAddButton() {
        addButton.setTitle("Добавить", for: .normal)
        addButton.backgroundColor = .gray
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func setUpResultLabel(user: User) {
        resultLabel.textColor = .darkTextColor
        resultLabel.text = user.name
    }
    
    // MARK: - Handlers
    
    @objc
    func searchFieldDidChange() {
        guard let text = searchTextField.text, !text.isEmpty else {
            return
        }
        presenter?.searchFieldDidChange(with: text)
    }
    
    @objc
    func addButtonTapped() {
        presenter?.addButtonTapped()
    }
}

extension FriendSearchController: FriendSearchView {
    func setPresenter(presenter: FriendSearchViewPresenter, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}
