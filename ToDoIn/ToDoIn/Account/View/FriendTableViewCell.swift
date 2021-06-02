import UIKit
import PinLayout

final class FriendTableViewCell: UITableViewCell {
    // Computable properties
    var friend: User? {
        didSet {
            guard let friend = friend else { return }
            friendAvatar.image = UIImage(named: "default")
            friendName.text = friend.name
        }
    }
    
    // Lazy stored properties
    private lazy var friendAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        label.textColor = .darkTextColor
        label.text = "Kamnev Vladimir Sergeevich Djan"
        return label
    }()
    
    private lazy var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreenColor
        view.isHidden = true
        return view
    }()
    
    // Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear.withAlphaComponent(0)
        setupViews()
        selectionStyle = .none
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
        contentView.addSubviews(friendView, friendName, selectedView)
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
            .end(20)
            .marginStart(10)
            .vCenter(to: friendView.edge.vCenter)
            .sizeToFit()
        selectedView.pin
            .right(10)
            .vCenter()
            .size(friendView.frame.height - 20)
    }
    
    private func configureViews() {
        if friendView.layer.cornerRadius == 0 {
            friendView.makeRound()
            friendAvatar.makeRound()
            selectedView.makeRound()

            friendView.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -2)
            friendView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 3)
        }
    }
    
    func setFriendAvatar(with image: UIImage?) {
        friendAvatar.image = image
    }
    
    func showUserIsSelectedView() {
        selectedView.isHidden.toggle()
    }
}
