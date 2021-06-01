import UIKit

final class FriendsTableView: UITableView {
    // Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupCells()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI configure methods
    private func setupViews() {
        backgroundColor = UIColor.clear
        separatorStyle = .none
        allowsSelection = false
    }
    
    private func setupCells() {
        register(FriendTableViewCell.self, forCellReuseIdentifier: String(describing: FriendTableViewCell.self))
    }
}

// MARK: - Friends TableViewDataSource

final class FriendsTVDataSource: NSObject, UITableViewDataSource {
    private weak var controller: FriendsTableViewOutput?
    
    
    init(controller: FriendsTableViewOutput) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = controller?.getAllFriends() else { return 0 }
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendTableViewCell.self), for: indexPath) as? FriendTableViewCell
        guard let controller = controller else {
            return UITableViewCell()
        }
        guard let safeCell = cell else {
            controller.showErrorAlertController(with: "Ячейки пользователей не могут быть созданы")
            return UITableViewCell()}
      
        let friend = controller.getFriend(by: indexPath.row)
        safeCell.friend = friend
        let friendImage = friend?.image
        if let friendImage = friendImage {
            controller.getPhoto(by: friendImage) { (image) in
                safeCell.setFriendAvatar(with: image)
            }
        }
        return safeCell
    }
}

// MARK: - Friends TableViewDelegate
final class FriendsTVDelegate: NSObject, UITableViewDelegate {
    
}

