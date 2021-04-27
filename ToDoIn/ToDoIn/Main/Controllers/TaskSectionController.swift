import UIKit
import PinLayout

class TaskSectionController: UIViewController, TaskSectionView {
    
    // MARK: - Properties
    
    private var presenter: TaskSectionViewPresenter?
    
    private var section: Section
    private var post: Post
    private let isChanging: Bool
    
    struct LayersConstants {
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let textFieldCornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
    }
    
    private let placeholderText = "Подготовиться к рк на следующей неделе"
    
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets, cornerRadius: LayersConstants.textFieldCornerRadius)
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let shadowDescriptionSubview = UIView()
    private let dateTextField = CustomTextField(insets: LayersConstants.textFieldInsets, cornerRadius: LayersConstants.textFieldCornerRadius)
    private let addButton = UIButton()
    
    // MARK: - Init
    
    init(section: Section, post: Post, isChanging: Bool) {
        self.section = section
        self.post = post
        self.isChanging = isChanging
        super.init(nibName: nil, bundle: nil)
        self.presenter = TaskSectionPresenter(taskSectionView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .accentColor
        view.addSubviews(titleLabel, nameLabel, nameTextField, descriptionLabel, descriptionTextView, dateTextField, addButton, shadowDescriptionSubview)
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
    
    override func viewDidLayoutSubviews() {
        configureLayouts()
        configureShadows()
    }
    
    // MARK: - Configures
    
    func configureLayouts() {
        titleLabel.pin
            .top(15).hCenter()
            .sizeToFit()
        
        nameLabel.pin
            .below(of: titleLabel, aligned: .center)
            .marginTop(35)
            .sizeToFit()
        
        nameTextField.pin
            .below(of: nameLabel)
            .marginTop(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(35)
        
        descriptionLabel.pin
            .below(of: nameTextField, aligned: .center)
            .marginTop(30)
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
            .marginTop(50)
            .horizontally(LayersConstants.horizontalPadding * 2)
            .height(35)
        
        addButton.pin
            .bottom(15)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.buttonHeight)
    }
    
    func configureLabels() {
        titleLabel.text = isChanging ? post.title : "Создать новую задачу"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.text = "Название"
        descriptionLabel.text = "Описание"
        [titleLabel, nameLabel, descriptionLabel].forEach { $0.textColor = .darkTextColor }
    }
    
    func configureNameTextField() {
        nameTextField.placeholder = "Поботать"
        nameTextField.textColor = .darkTextColor
        nameTextField.backgroundColor = .white
        nameTextField.text = post.title
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
        
        if post.description == "" {
            descriptionTextView.text = placeholderText
            descriptionTextView.textColor = .lightTextColor
        } else {
            descriptionTextView.text = post.description
            descriptionTextView.textColor = .darkTextColor
        }
    }
    
    func configurePickers() {
        dateTextField.textColor = .darkTextColor
        dateTextField.backgroundColor = .white
        dateTextField.textAlignment = .center
        dateTextField.placeholder = "Выбрать время"
        
        self.dateTextField.setInputViewTimePicker(target: self, selector: #selector(doneDateTapped))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateTextField.text = dateformatter.string(from: post.date ?? Date())
    }

    func configureAddButton() {
        addButton.setTitle(isChanging ? "Изменить" : "Добавить", for: .normal)
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
        [nameTextField, shadowDescriptionSubview, dateTextField, addButton].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
        [nameTextField, shadowDescriptionSubview, dateTextField, addButton].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
    }
    
    // MARK: - Handlers
    
    func setDate(with date: String) {
        dateTextField.text = date
    }
    
    @objc
    func doneDateTapped() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            presenter?.doneDateTapped(date: datePicker.date)
        }
        self.dateTextField.resignFirstResponder()
    }
    
    @objc
    func addButtonTapped() {
        presenter?.buttonTapped(post: post, section: section, isChanging: isChanging)
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extensions

extension TaskSectionController: UITextViewDelegate {
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
