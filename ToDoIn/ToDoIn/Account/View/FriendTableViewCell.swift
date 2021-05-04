import UIKit
import PinLayout

class FriendTableViewCell: UITableViewCell {
    // Computable properties
    var friend: FriendModelProtocol? {
        didSet {
            guard let friend = friend else { return }
            friendAvatar.image = friend.image
            friendName.text = friend.name
        }
    }
    
    // Lazy stored properties
    private lazy var friendAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var friendView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private lazy var friendName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        label.text = "Kamnev Vladimir Sergeevich Djan"
        return label
    }()
    
    // Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear.withAlphaComponent(0)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // UI configure methods
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        setupLayouts()
        configureViews()
        return CGSize(width: contentView.frame.width, height: friendView.frame.height + 10)
    }
    
    private func setupViews() {
        contentView.addSubviews(friendView, friendName)
        friendView.addSubview(friendAvatar)
        friendAvatar.backgroundColor = .systemGray3
    }
    private func setupLayouts() {
        friendView.pin
            .top()
            .bottom(5)
            .start(20)
            .size(53)
        friendAvatar.pin
            .all()
            .margin(3)
        friendName.pin
            .start(to: friendView.edge.end)
            .width(100)
            .marginStart(10)
            .vCenter(to: friendView.edge.vCenter)
            .sizeToFit()
    }
    
    private func configureViews() {
        if friendView.layer.cornerRadius == 0 {
            friendView.makeRound()
            friendAvatar.makeRound()

            friendView.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -2)
            friendView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 3)
        }
    }
}
