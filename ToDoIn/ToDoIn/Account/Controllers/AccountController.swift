import UIKit

protocol AccountView: class {
    
}

class AccountController: UIViewController {

    // MARK: - Properties
    
    private var presenter: GroupViewPresenter?
    
    private var addFriendsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }

}

extension AccountController: AccountView {
    
}
