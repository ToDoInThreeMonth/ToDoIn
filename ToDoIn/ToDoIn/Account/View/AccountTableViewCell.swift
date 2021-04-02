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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        contentView.addSubviews(friendView, friendName)
        friendView.addSubview(friendAvatar)
        friendAvatar.backgroundColor = .systemGray3
    }
    private func setupLayouts() {
        friendView.pin
            .size(50)
            .top()
            .bottom()
            .start()
            .marginStart(20)
        friendAvatar.pin
            .all()
            .margin(3)
        friendName.pin
            .start(to: friendView.edge.end)
            .width(100)
            .marginStart(10)
            .vCenter(to: friendView.edge.vCenter)
            .sizeToFit()
        
        friendView.makeRound()
        friendAvatar.makeRound()
        
        friendView.insertBackLayer()
        friendView.addOneMoreShadow(color: .black, alpha: 0.2, x: 1, y: 1, blur: 2, cornerRadius: friendView.layer.cornerRadius)
        friendView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 2, cornerRadius: friendView.layer.cornerRadius)
    }
    
    
}
