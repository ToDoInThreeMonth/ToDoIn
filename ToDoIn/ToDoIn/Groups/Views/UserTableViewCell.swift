import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "SettingsGroupCell"
    
    private var backView = UIView()
    private var userName = UILabel()
    private var userImage = UIImageView()
    
    private let imagePadding: CGFloat = 6

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        [userName, backView].forEach {addSubview($0)}
        backView.addSubview(userImage)
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
        
        backView.pin
            .left(10).vCenter()
            .size(self.frame.height - imagePadding * 2)
        
        userImage.pin
            .all()
            .margin(imagePadding)
        
        userName.pin
            .after(of: backView, aligned: .center)
            .marginLeft(10)
            .sizeToFit()
    }
    
    func setupSublayers() {
        configureBackView()
        configureUserName()
        configureUserImageView()
    }
    
    func configureBackView() {
        backView.makeRound()
        backView.backgroundColor = .accentColor
        backView.addShadow(side: .bottomRight, type: .outside, alpha: 0.15)
        backView.addShadow(side: .bottomRight, type: .outside, color: .white, alpha: 1, offset: -5)
        backView.addShadow(side: .topLeft, type: .innearRadial, color: .white, power: 0.15, alpha: 1, offset: 1)
        backView.addShadow(side: .bottomRight, type: .innearRadial, power: 0.15, offset: 10)
    }
    
    func configureUserName() {
        userName.textColor = .darkTextColor
        userName.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    func configureUserImageView() {
        userImage.makeRound()
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        userImage.addShadow(side: .topLeft, type: .innearRadial, power: 0.1, alpha: 0.3, offset: 10)
        userImage.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.1, alpha: 0.5, offset: 10)
    }
    
    
    func setUp(userName: String, userImage: String) {
        self.userName.text = userName
        self.userImage.image = UIImage(named: userImage)
    }

}
