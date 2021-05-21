import UIKit
import PinLayout

protocol TaskView: AnyObject {
    func setPresenter(presenter: TaskViewPresenter, coordinator: GroupsChildCoordinator)

    func setDate(with date: String)
    func setUser(with name: String)
}

final class TaskController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: TaskViewPresenter?
    
    private var group: Group
    private var task: Task
    private var users: [User]
    private let isChanging: Bool
    
    struct LayersConstants {
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let textFieldCornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
    }
    
    private let placeholderText = "Описание задачи..."
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let shadowDescriptionSubview = UIView()
    private let dateTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let userTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let isDoneView = UIView()
    private let addButton = CustomButton()
    private let deleteButton = CustomButton(with: "Удалить")
    
    // MARK: - Init
    
    init(group: Group, task: Task, users: [User], isChanging: Bool) {
        self.group = group
        self.task = task
        self.isChanging = isChanging
        self.users = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        if isChanging {
            view.addSubview(deleteButton)
        }
        view.addSubviews(titleLabel, nameLabel, nameTextField, descriptionLabel, descriptionTextView, dateTextField, userTextField, addButton, shadowDescriptionSubview, isDoneView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureLabels()
        configureNameTextField()
        configureDescriptionTextView()
        configurePickers()
        configureButtons()
        configureIsDoneView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayouts()
        configureShadowsAndCornerRadius()
    }
    
    // MARK: - Configures
    
    private func configureLayouts() {
        titleLabel.pin
            .top(15).hCenter()
            .sizeToFit()
        
        nameLabel.pin
            .below(of: titleLabel, aligned: .center)
            .marginTop(25)
            .sizeToFit()
        
        nameTextField.pin
            .below(of: nameLabel)
            .marginTop(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(35)
        
        descriptionLabel.pin
            .below(of: nameTextField, aligned: .center)
            .marginTop(15)
            .sizeToFit()
        
        shadowDescriptionSubview.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(150)
        
        descriptionTextView.pin
            .below(of: descriptionLabel)
            .marginTop(15)
            .horizontally(10)
            .height(150)
        
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
        
        if isChanging {
            isDoneView.pin
                .below(of: userTextField, aligned: .center)
                .marginTop(20)
                .size(CGSize(width: 40, height: 40))
            
            deleteButton.pin
                .bottom(view.pin.safeArea.bottom + 20)
                .hCenter()
            
            addButton.pin
                .above(of: deleteButton, aligned: .center)
                .marginBottom(15)
        } else {
            addButton.pin
                .bottom(view.pin.safeArea.bottom + 20)
                .hCenter()
        }

    }
    
    private func configureLabels() {
        titleLabel.text = isChanging ? task.title : "Создать новую задачу"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.text = "Название"
        descriptionLabel.text = "Описание"
        [titleLabel, nameLabel, descriptionLabel].forEach { $0.textColor = .darkTextColor }
    }
    
    private func configureNameTextField() {
        nameTextField.placeholder = "Название задачи"
        nameTextField.textColor = .darkTextColor
        nameTextField.backgroundColor = .white
        nameTextField.text = task.title
    }
    
    private func configureDescriptionTextView() {
        shadowDescriptionSubview.backgroundColor = .white
        
        descriptionTextView.text = placeholderText
        descriptionTextView.textColor = .lightTextColor
        descriptionTextView.backgroundColor = .white
        
        descriptionTextView.delegate = self
        
        shadowDescriptionSubview.insertSubview(descriptionTextView, at: 0)
        
        if task.description.isEmpty {
            descriptionTextView.text = placeholderText
            descriptionTextView.textColor = .lightTextColor
        } else {
            descriptionTextView.text = task.description
            descriptionTextView.textColor = .darkTextColor
        }
    }
    
    private func configurePickers() {
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

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateTextField.text = dateformatter.string(from: task.date)
        userTextField.text = presenter?.getUser(by: task.userId, in: users).name
    }
    
    private func configureIsDoneView() {
        isDoneView.backgroundColor = task.isDone ? UIColor.lightGreenColor : UIColor.lightRedColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(isDoneViewTapped))
        isDoneView.addGestureRecognizer(tap)
    }

    private func configureButtons() {
        addButton.setTitle(isChanging ? "Изменить" : "Добавить")
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func configureShadowsAndCornerRadius() {
        if nameTextField.layer.cornerRadius == 0 {
            [nameTextField, shadowDescriptionSubview, dateTextField, userTextField].forEach { $0.layer.cornerRadius = LayersConstants.cornerRadius }
            [nameTextField, shadowDescriptionSubview, dateTextField, userTextField].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
            [nameTextField, shadowDescriptionSubview, dateTextField, userTextField].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
            isDoneView.makeRound()
        }
    }
    
    // MARK: - Handlers
    
    @objc
    private func doneDateTapped() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            presenter?.doneDateTapped(date: datePicker.date)
        }
        self.dateTextField.resignFirstResponder()
    }
    
    @objc
    private func doneUserTapped() {
        if let userPicker = self.userTextField.inputView as? UIPickerView {
            presenter?.doneUserTapped(user: users[userPicker.selectedRow(inComponent: 0)])
        }
        self.userTextField.resignFirstResponder()
    }
    
    @objc
    private func addButtonTapped() {
        guard let title = nameTextField.text, !title.isEmpty, !(userTextField.text?.isEmpty ?? true) else {
            dismiss(animated: true, completion: nil)
            return
        }
        var date = task.date
        var userId = task.userId
        if let userPicker = self.userTextField.inputView as? UIPickerView,
           let datePicker = self.dateTextField.inputView as? UIDatePicker {
            if userTextField.text == users[userPicker.selectedRow(inComponent: 0)].name {
                userId = users[userPicker.selectedRow(inComponent: 0)].id
            }
            if dateTextField.text == datePicker.date.toString() {
                date = datePicker.date
            }
        }
        var newTask = Task(userId: userId, title: title, description: descriptionTextView.text, date: date, isDone: task.isDone)
        if isChanging {
            newTask.id = task.id
        }
        presenter?.addButtonTapped(isChanging, task: newTask, group: group)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func deleteButtonTapped() {
        presenter?.showDeleteAlertController(on: self, completion: {
            self.presenter?.deleteButtonTapped(task: self.task, group: self.group)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc
    private func isDoneViewTapped() {
        task.isDone.toggle()
        isDoneView.backgroundColor = task.isDone ? UIColor.lightGreenColor : UIColor.lightRedColor
    }
}


// MARK: - Extensions

extension TaskController: TaskView {
    
    func setPresenter(presenter: TaskViewPresenter, coordinator: GroupsChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func setDate(with date: String) {
        dateTextField.text = date
    }
    
    func setUser(with name: String) {
        userTextField.text = name
    }
}

extension TaskController: UITextViewDelegate {
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
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightTextColor
        }
    }
    
}


extension TaskController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        group.users.count
    }

}

extension TaskController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        users[row].name
    }

}
