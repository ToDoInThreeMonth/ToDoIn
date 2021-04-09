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
    private let addButton = CustomButton(title: "Добавить")
    
    private let cornerRadius: CGFloat = 15
    private let horizontalPadding: CGFloat = 40
    
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
            
        configureLabels()
        configureNameTextField()
        configureDescriptionTextView()
        configureDataPicker()
        configureUserPicker()
        configureAddButton()
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
            .horizontally(15)
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
            .size(CGSize(width: 200, height: 40))
        
        userPicker.pin
            .below(of: datePicker)
            .marginTop(10)
            .horizontally(horizontalPadding)
            .height(horizontalPadding)
        
        addButton.pin
            .bottom(15)
            .horizontally(horizontalPadding)
            .height(horizontalPadding)
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
        nameTextField.addMyShadow(color: .black, offset: CGSize(width: 0, height: -1), radius: 2, opacity: 0.10)
    }
    
    func configureDescriptionTextView() {
        shadowDescriptionSubview.backgroundColor = .white
        shadowDescriptionSubview.layer.cornerRadius = cornerRadius
        shadowDescriptionSubview.addMyShadow(color: .black, offset: CGSize(width: 0, height: -1), radius: 2, opacity: 0.10)
        
        descriptionTextView.layer.cornerRadius = cornerRadius
        descriptionTextView.textColor = .darkTextColor
        descriptionTextView.backgroundColor = .white
        
        shadowDescriptionSubview.insertSubview(descriptionTextView, at: 0)
    }
    
    func configureDataPicker() {
        datePicker.backgroundColor = .clear
        datePicker.minimumDate = Date()
    }
    
    func configureUserPicker() {
        shadowUserPickerSubview.backgroundColor = .white
        shadowUserPickerSubview.layer.cornerRadius = cornerRadius
        shadowUserPickerSubview.addMyShadow(color: .black, offset: CGSize(width: 0, height: -1), radius: 2, opacity: 0.10)
        
        userPicker.dataSource = self
        userPicker.delegate = self
        userPicker.backgroundColor = .white
        userPicker.layer.cornerRadius = cornerRadius
        
        
        shadowUserPickerSubview.insertSubview(userPicker, at: 0)
    }

    func configureAddButton() {
        addButton.layer.cornerRadius = cornerRadius
    }
}


// MARK: - Extensions

extension AddingTaskController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return group.owners.count
    }
    
    
}

extension AddingTaskController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let userView = UserPickerCell(userName: group.owners[row].owner)
        return userView
    }
}


extension UIView {
    
    func addMyShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}

