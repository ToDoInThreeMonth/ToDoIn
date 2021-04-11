import UIKit
import PinLayout

class AddingTaskController: UIViewController {
    
    // MARK: - Properties
    
    private let group: Group
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), cornerRadius: 15)
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let shadowDescriptionSubview = UIView()
    private let datePicker = UIDatePicker()
    private let userPicker = UIPickerView()
    private let shadowUserPickerSubview = UIView()
    private let addButton = UIButton()
    
    private let userPickerSize = CGSize(width: 240, height: 40)
    private let buttonHeight: CGFloat = 40
    private let cornerRadius: CGFloat = 15
    private let horizontalPadding: CGFloat = 40
    private let placeholderText = "Подготовиться к рк на следующую неделю"
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Handlers
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        view.addSubviews(titleLabel, nameLabel, nameTextField, descriptionLabel, descriptionTextView, datePicker, userPicker, addButton, shadowDescriptionSubview, shadowUserPickerSubview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureLabels()
        configureNameTextField()
        configureDescriptionTextView()
        configureDataPicker()
        configureUserPicker()
        configureAddButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureShadows()
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.pin
            .top(10).hCenter()
            .sizeToFit()
        
        nameLabel.pin
            .below(of: titleLabel, aligned: .center)
            .marginTop(40)
            .sizeToFit()
        
        nameTextField.pin
            .below(of: nameLabel)
            .marginTop(15)
            .horizontally(horizontalPadding)
            .height(35)
        
        descriptionLabel.pin
            .below(of: nameTextField, aligned: .center)
            .marginTop(20)
            .sizeToFit()
        
        shadowDescriptionSubview.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(horizontalPadding)
            .height(140)
        
        descriptionTextView.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(10)
            .height(140)
        
        datePicker.pin
            .below(of: descriptionTextView)
            .hCenter()
            .marginTop(10)
            .sizeToFit()
        
        shadowUserPickerSubview.pin
            .below(of: datePicker)
            .hCenter()
            .marginTop(10)
            .size(userPickerSize)
        
        userPicker.pin
            .below(of: datePicker)
            .hCenter()
            .marginTop(10)
            .size(userPickerSize)
        
        addButton.pin
            .bottom(15)
            .horizontally(horizontalPadding)
            .height(buttonHeight)
    }
    
    func configureLabels() {
        titleLabel.text = "Создание новой задачи"
        nameLabel.text = "Название"
        descriptionLabel.text = "Описание"
        [titleLabel, nameLabel, descriptionLabel].forEach { $0.textColor = .darkTextColor }
    }
    
    func configureNameTextField() {
        nameTextField.placeholder = "Поботать"
        nameTextField.textColor = .darkTextColor
        nameTextField.backgroundColor = .white
    }
    
    func configureDescriptionTextView() {
        shadowDescriptionSubview.backgroundColor = .white
        shadowDescriptionSubview.layer.cornerRadius = cornerRadius
        
        descriptionTextView.layer.cornerRadius = cornerRadius
        descriptionTextView.text = placeholderText
        descriptionTextView.textColor = .lightTextColor
        descriptionTextView.backgroundColor = .white
        
        descriptionTextView.delegate = self
        
        shadowDescriptionSubview.insertSubview(descriptionTextView, at: 0)
    }
    
    func configureDataPicker() {
        datePicker.backgroundColor = .clear
        datePicker.minimumDate = Date()
    }
    
    func configureUserPicker() {
        shadowUserPickerSubview.backgroundColor = .white
        shadowUserPickerSubview.layer.cornerRadius = cornerRadius
        
        userPicker.dataSource = self
        userPicker.delegate = self
        userPicker.backgroundColor = .white
        userPicker.layer.cornerRadius = cornerRadius
        
        shadowUserPickerSubview.insertSubview(userPicker, at: 0)
    }

    func configureAddButton() {
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(.darkTextColor, for: .normal)
        addButton.layer.cornerRadius = cornerRadius
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - horizontalPadding * 2, height: buttonHeight)
        gradientLayer.cornerRadius = addButton.layer.cornerRadius
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.accentColor.cgColor]
        addButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureShadows() {
        [nameTextField, shadowDescriptionSubview, shadowUserPickerSubview, addButton].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
        [nameTextField, shadowDescriptionSubview, shadowUserPickerSubview, addButton].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
    }
}


// MARK: - Extensions

extension AddingTaskController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return group.owners.count + 1
    }

}

extension AddingTaskController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if row == 0 {
            return UserPickerCell("Адресовать пользователю")
        }
        let userView = UserPickerCell(userName: group.owners[row - 1].owner)
        return userView
    }
    
}

extension AddingTaskController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .darkTextColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = .lightTextColor
        }
    }
    
}
