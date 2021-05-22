import UIKit

// Alert Controllers factory
struct AlertControllerCreator {
    // Nested data types
    enum TypeAlert {
        case logOut
        case error
        case section
        case deleteSection
    }
    
    // Static functions
    static func getController (title: String?, message: String?, style: UIAlertController.Style, type: TypeAlert) -> UIAlertController {
        switch type {
        case .logOut:
            let alertController = ExitAlertController(title: title, message: message, preferredStyle: style)
            return alertController
        case .error:
            let alertController = ErrorAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .section:
            let alertController = SectionAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .deleteSection:
            let alertController = DeleteAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        }
    }
}

class ExitAlertController: UIAlertController {
    var onButtonTapped: (() -> ())?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let agreeButton = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Да", style: .destructive) {[unowned self] _ in
            disagreeButtonTapped()
        }
        addAction(disagreeButton)
        addAction(agreeButton)
    }
    
    private func disagreeButtonTapped() {
        onButtonTapped?()
    }
}

class ErrorAlertController: UIAlertController {
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let reportButton = UIAlertAction(title: "Сообщить об ошибке", style: .default) { [unowned self] _ in
            print(self.message)
        }
        addAction(reportButton)
    }
}

class SectionAlertController: UIAlertController {
    weak var delegate: SectionAlertDelegate?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTextField()
    }
    
    // UI configure methods
    private func setupButton() {
        let addButton = UIAlertAction(title: "Добавить", style: .cancel) { [unowned self] _ in
            guard let text = self.textFields?[0].text else { return }
            self.delegate?.addNewSection(with: text)
        }
        let closeButton = UIAlertAction(title: "Отменить", style: .default)
        addAction(addButton)
        addAction(closeButton)
    }
    
    private func setupTextField() {
        addTextField { textField in
            textField.placeholder = "Работа"
        }
    }
}

class DeleteAlertController: UIAlertController {
    weak var delegate: DeleteAlertDelegate?
    var section: Int?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let addButton = UIAlertAction(title: "Отменить", style: .cancel)
        let closeButton = UIAlertAction(title: "Удалить", style: .default) { [unowned self] _ in
            guard let section = self.section else { return }
            self.delegate?.deleteSection(section)
        }
        addAction(addButton)
        addAction(closeButton)
    }
    
}
