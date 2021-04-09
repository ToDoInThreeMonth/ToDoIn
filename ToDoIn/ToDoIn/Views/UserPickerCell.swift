import UIKit

class UserPickerCell: UIView {
        
    private let userlabel = UILabel()
    
    init(userName: String) {
        super.init(frame: .zero)
        userlabel.text = userName
        userlabel.textColor = .darkTextColor
        addSubview(userlabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        userlabel.pin.center().sizeToFit()
    }
}
