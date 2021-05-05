import UIKit

protocol AccountView: class {
    func setPresenter(presenter: AccountViewPresenter, coordinator: AccountChildCoordinator)
}

class AccountController: UIViewController {

    // MARK: - Properties
    
    private var presenter: AccountViewPresenter?
    
    private var addFriendsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        addFriendsButton.setTitle("Добавить друзей", for: .normal)
        addFriendsButton.backgroundColor = .gray
        addFriendsButton.addTarget(self, action: #selector(addFriendsButtonTapped), for: .touchUpInside)
        view.addSubview(addFriendsButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addFriendsButton.pin.center().sizeToFit()
    }
    
    @objc
    func addFriendsButtonTapped() {
        presenter?.addFriendsButtonTapped()
    }

}

extension AccountController: AccountView {
    func setPresenter(presenter: AccountViewPresenter, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}
