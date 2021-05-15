import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "SettingsGroupCell"
    
    private var userName = UILabel()
    private var userImage = UIImageView()
    
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
    
    
    // MARK: - Handlers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupSublayers()
    }
    
    func setupLayouts() {
        
        userImage.pin
            .left(10).vCenter()
            .size(self.frame.height - imagePadding * 2)
        
        userName.pin
            .after(of: userImage, aligned: .center)
            .marginLeft(10)
            .sizeToFit()
    }
    
    func setupSublayers() {
        configureUserName()
        configureUserImageView()
    }
    
    func configureUserName() {
        userName.textColor = .darkTextColor
        userName.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    func configureUserImageView() {
        userImage.makeRound()
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
    }
    
    
    func setUp(user: User) {
        self.userName.text = user.name
        self.userImage.image = UIImage(named: user.image)
    }

}

