import UIKit
import PinLayout

class AddingTaskController: UIViewController, AddingTaskView {
    
    // MARK: - Properties
    
    lazy var presenter = AddingTaskPresenter(addingTaskView: self)
    
    private var group = Group()
    
    struct LayersConstants {
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let textFieldCornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
    }
    
    private let placeholderText = "Подготовиться к рк на следующую неделю"
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets, cornerRadius: LayersConstants.textFieldCornerRadius)
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let shadowDescriptionSubview = UIView()
    private let dateTextField = CustomTextField(insets: LayersConstants.textFieldInsets, cornerRadius: LayersConstants.textFieldCornerRadius)
    private let userTextField = CustomTextField(insets: LayersConstants.textFieldInsets, cornerRadius: LayersConstants.textFieldCornerRadius)
    private let addButton = UIButton()
    
    // MARK: - Init
    
    init(group: Group) {
        super.init(nibName: nil, bundle: nil)
        self.group = group
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Handlers
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        view.addSubviews(titleLabel, nameLabel, nameTextField, descriptionLabel, descriptionTextView, dateTextField, userTextField, addButton, shadowDescriptionSubview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureLabels()
        configureNameTextField()
        configureDescriptionTextView()
        configurePickers()
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
            .horizontally(LayersConstants.horizontalPadding)
            .height(35)
        
        descriptionLabel.pin
            .below(of: nameTextField, aligned: .center)
            .marginTop(20)
            .sizeToFit()
        
        shadowDescriptionSubview.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(200)
        
        descriptionTextView.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(10)
            .height(200)
        
        dateTextField.pin
            .below(of: descriptionTextView)
            .marginTop(30)
            .horizontally(LayersConstants.horizontalPadding * 2)
            .height(35)
        
        userTextField.pin
            .below(of: dateTextField)
            .marginTop(30)
            .horizontally(LayersConstants.horizontalPadding * 2)
            .height(35)
        
        addButton.pin
            .bottom(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.buttonHeight)
    }
    
    func configureLabels() {
        titleLabel.text = "Создать новую задачу"
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
        shadowDescriptionSubview.layer.cornerRadius = LayersConstants.cornerRadius
        
        descriptionTextView.layer.cornerRadius = LayersConstants.cornerRadius
        descriptionTextView.text = placeholderText
        descriptionTextView.textColor = .lightTextColor
        descriptionTextView.backgroundColor = .white
        
        descriptionTextView.delegate = self
        
        shadowDescriptionSubview.insertSubview(descriptionTextView, at: 0)
    }
    
    func configurePickers() {
        [dateTextField, userTextField].forEach {
            $0.textColor = .darkTextColor
            $0.backgroundColor = .white
            $0.textAlignment = .center
        }
        dateTextField.placeholder = "Выбрать время"
        userTextField.placeholder = "Адресовать пользователю"

        self.dateTextField.setInputViewTimePicker(target: self, selector: #selector(doneDateTapped))
        
        let screenWidth = UIScreen.main.bounds.width
        let userPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        userPicker.dataSource = self
        userPicker.delegate = self
        self.userTextField.setInputViewUserPicker(with: userPicker, target: self, selector: #selector(doneUserTapped))

    }

    func configureAddButton() {
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(.darkTextColor, for: .normal)
        addButton.layer.cornerRadius = LayersConstants.cornerRadius
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - LayersConstants.horizontalPadding * 2, height: LayersConstants.buttonHeight)
        gradientLayer.cornerRadius = addButton.layer.cornerRadius
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.accentColor.cgColor]
        addButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureShadows() {
        [nameTextField, shadowDescriptionSubview, dateTextField, userTextField, addButton].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
        [nameTextField, shadowDescriptionSubview, dateTextField, userTextField, addButton].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
    }
    
    @objc
    func doneDateTapped() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            presenter.doneDateTapped(date: datePicker.date)
        }
        self.dateTextField.resignFirstResponder()
    }
    
    @objc
    func doneUserTapped() {
        if let userPicker = self.userTextField.inputView as? UIPickerView {
            presenter.doneUserTapped(user: group.users[userPicker.selectedRow(inComponent: 0)])
        }
        self.userTextField.resignFirstResponder()
    }
    
    @objc
    func addButtonTapped() {
        // добавление задачи в комнату
        presenter.addButtonTapped()
        dismiss(animated: true, completion: nil)
    }
    
    func setDate(with date: String) {
        dateTextField.text = date
    }
    
    func setUser(with name: String) {
        userTextField.text = name
    }
}


// MARK: - Extensions

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


extension AddingTaskController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return group.users.count
    }

}

extension AddingTaskController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return group.users[row].name
    }

}
