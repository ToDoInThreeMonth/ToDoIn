import UIKit
import PinLayout

class AccountTableViewCell: UITableViewCell {
    var friend: Friend? {
        didSet {
            guard let friend = friend else { return }
            friendAvatar.image = friend.image
            friendName.text = friend.name
        }
    }
    
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        label.text = "Kamnev Vladimir Sergeevich Djan"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear.withAlphaComponent(0)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
            .size(45)
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

            friendView.insertBackLayer()
            friendView.addOneMoreShadow(color: .black, alpha: 0.2, x: 1, y: 1, blur: 2, cornerRadius: friendView.layer.cornerRadius)
            friendView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 2, cornerRadius: friendView.layer.cornerRadius)
        }
    }
}
