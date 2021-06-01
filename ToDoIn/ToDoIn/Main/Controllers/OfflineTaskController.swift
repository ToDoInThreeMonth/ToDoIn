import UIKit
import PinLayout

protocol OfflineTaskView: class {
    func setPresenter(presenter: OfflineTaskPresenter, coordinator: MainChildCoordinator)
    func setDate(with date: String)
}

final class OfflineTaskController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: OfflineTaskViewPresenter?
    
    private var task: Task
    private var indexPath: IndexPath
    private var isChanging: Bool
    private var isArchive: Bool
    private var isDone: Bool = false
    weak var delegate: MainTableViewOutput?
        
    private struct LayersConstants {
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
    private let isDoneView = UIView()
    private let addButton = CustomButton()
    private let deleteButton = CustomButton(with: "Удалить")
    
    // MARK: - Init
    
    init(task: OfflineTask = OfflineTask(), indexPath: IndexPath, isChanging: Bool = false, isArchive: Bool = false) {
        self.task = Task(id: "", userId: "", title: task.title, description: task.descriptionText, date: task.date, isDone: false)
        self.indexPath = indexPath
        self.isChanging = isChanging
        self.isArchive = isArchive
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        if isChanging || isArchive {
            view.addSubview(deleteButton)
        }
        if !isArchive {
            view.addSubview(addButton)
        }
        view.addSubviews(titleLabel, nameLabel, nameTextField, descriptionLabel, descriptionTextView, dateTextField, shadowDescriptionSubview, isDoneView)
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
        
        if isChanging {
            isDoneView.pin
                .below(of: dateTextField, aligned: .center)
                .marginTop(20)
                .size(CGSize(width: 40, height: 40))
            
            deleteButton.pin
                .bottom(view.pin.safeArea.bottom + 20)
                .hCenter()
            
            addButton.pin
                .above(of: deleteButton, aligned: .center)
                .marginBottom(15)
        } else if isArchive {
            deleteButton.pin
                .bottom(view.pin.safeArea.bottom + 20)
                .hCenter()
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
        if isArchive {
            nameTextField.isUserInteractionEnabled = true
        }
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
        if isArchive {
            descriptionTextView.isUserInteractionEnabled = true
        }
    }
    
    private func configurePickers() {
        [dateTextField].forEach {
            $0.textColor = .darkTextColor
            $0.backgroundColor = .white
            $0.textAlignment = .center
        }
        dateTextField.placeholder = "Выбрать время"

        self.dateTextField.setInputViewTimePicker(target: self, selector: #selector(doneDateTapped))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateTextField.text = dateformatter.string(from: task.date)
        if isArchive {
            dateTextField.isUserInteractionEnabled = true
        }
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
            [nameTextField, shadowDescriptionSubview, dateTextField].forEach { $0.layer.cornerRadius = LayersConstants.cornerRadius }
            [nameTextField, shadowDescriptionSubview, dateTextField].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
            [nameTextField, shadowDescriptionSubview, dateTextField].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
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
    func addButtonTapped() {
        let task = getTask()
        if isDone {
            presenter?.taskIsComplete(in: indexPath)
        } else if isChanging {
            presenter?.changeTask(task, in: indexPath)
        } else {
            presenter?.addTask(task, in: indexPath)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func deleteButtonTapped() {
        presenter?.showDeleteAlertController(on: self) {
            self.presenter?.deleteButtonTapped(section: self.indexPath.section, row: self.indexPath.row, isArchive: self.isArchive)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func isDoneViewTapped() {
        isDone.toggle()
        isDoneView.backgroundColor = isDone ? UIColor.lightGreenColor : UIColor.lightRedColor
    }
    
    private func getTask() -> OfflineTask {
        let task = OfflineTask()
        guard let description = descriptionTextView.text else {
            return task
        }
        guard let title = nameTextField.text else {
            return task
        }
        var date = self.task.date
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            if dateTextField.text == datePicker.date.toString() {
                date = datePicker.date
            }
        }
        task.date = date
        task.descriptionText = (description == placeholderText) ? "" : description
        task.title = title
        return task
    }
}


// MARK: - Extensions

extension OfflineTaskController: OfflineTaskView {
    
    func setPresenter(presenter: OfflineTaskPresenter, coordinator: MainChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
    
    func setDate(with date: String) {
        dateTextField.text = date
    }
}

extension OfflineTaskController: UITextViewDelegate {
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

