import UIKit

class CustomTextField: UITextField {
    
    let insets: UIEdgeInsets

    init(insets: UIEdgeInsets, cornerRadius: CGFloat) {
        self.insets = insets
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightTextColor])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
}
