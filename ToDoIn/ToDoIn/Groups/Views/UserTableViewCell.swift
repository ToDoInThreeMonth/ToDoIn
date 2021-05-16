import UIKit

final class UserTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "SettingsGroupCell"
    
    private let userName = UILabel()
    private let userImage = UIImageView()
    
    private let imagePadding: CGFloat = 6

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        [userName, userImage].forEach {addSubview($0)}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupSublayers()
    }
    
    // MARK: - Configures
    
    private func setupLayouts() {
        userImage.pin
            .left(10).vCenter()
            .size(self.frame.height - imagePadding * 2)
        
        userName.pin
            .after(of: userImage, aligned: .center)
            .marginLeft(10)
            .sizeToFit()
    }
    
    private func setupSublayers() {
        configureUserName()
        configureUserImageView()
    }
    
    private func configureUserName() {
        userName.textColor = .darkTextColor
        userName.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    private func configureUserImageView() {
        userImage.makeRound()
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
    }
    
    // MARK: - Handlers
    
    func setUp(user: User) {
        self.userName.text = user.name
        self.userImage.image = UIImage(named: user.image)
    }

}

