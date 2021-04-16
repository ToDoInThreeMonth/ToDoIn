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
    
    func setInputViewTimePicker(target: Any, selector: Selector, mode: UIDatePicker.Mode) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = mode
        if (mode == UIDatePicker.Mode.date) {
            datePicker.minimumDate = Date()
        }
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        self.inputView = datePicker
        
        configureToolBar(screenWidth: screenWidth, selector: selector)
    }
    
    func setInputViewUserPicker(with userPicker: UIPickerView, target: Any, selector: Selector) {
        self.inputView = userPicker
        let screenWidth = UIScreen.main.bounds.width
        configureToolBar(screenWidth: screenWidth, selector: selector)

    }
    
    func configureToolBar(screenWidth: CGFloat, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }

}
