import UIKit

// Alert Controllers factory
struct AlertControllerCreator {
    // Nested data types
    enum TypeAlert {
        case logOut
        case error
        case addSection
        case deleteSection
        case deleteTask
        case changeSection
        case signIn
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
        case .addSection:
            let alertController = AddSectionAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .changeSection:
            let alertController = ChangeSectionAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .deleteSection:
            let alertController = DeleteSectionAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .deleteTask:
            let alertController = DeleteTaskAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        case .signIn:
            let alertController = PleaseSignInAlertController(title: title, message: message, preferredStyle: .alert)
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
        let reportButton = UIAlertAction(title: "Сообщить об ошибке", style: .default)
        addAction(reportButton)
    }
}

class AddSectionAlertController: UIAlertController {
    weak var delegate: AddSectionAlertDelegate?
    
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
        addAction(addButton)
        
        let closeButton = UIAlertAction(title: "Отменить", style: .default)
        
        addAction(closeButton)
    }
    
    private func setupTextField() {
        addTextField { textField in
            textField.placeholder = "Работа"
        }
    }
}

class ChangeSectionAlertController: UIAlertController {
    weak var delegate: ChangeSectionAlertDelegate?
    var section: Int?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTextField()
    }
    
    // UI configure methods
    private func setupButton() {
        let addButton = UIAlertAction(title: "Cохранить", style: .cancel) { [unowned self] _ in
            guard let text = self.textFields?[0].text,
                  let section = section
            else { return }
            
            self.delegate?.changeSection(with: section, text: text)
        }
        addAction(addButton)
        
        let closeButton = UIAlertAction(title: "Отменить", style: .default)
        
        addAction(closeButton)
    }
    
    private func setupTextField() {
        addTextField { textField in
            textField.placeholder = "Работа"
        }
    }
}

class DeleteSectionAlertController: UIAlertController {
    weak var delegate: DeleteAlertDelegate?
    var section: Int?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) { [unowned self] _ in
            guard let section = self.section else { return }
            self.delegate?.deleteSection(section)
        }
        addAction(cancelButton)
        addAction(deleteButton)
    }
    
}

class DeleteTaskAlertController: UIAlertController {
    var onButtonTapped: (() -> ())?
    
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let agreeButton = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Удалить", style: .destructive) {[unowned self] _ in
            disagreeButtonTapped()
        }
        addAction(disagreeButton)
        addAction(agreeButton)
    }
    
    private func disagreeButtonTapped() {
        onButtonTapped?()
    }
}


class PleaseSignInAlertController: UIAlertController {
    // ViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    // UI configure methods
    private func setupButton() {
        let reportButton = UIAlertAction(title: "Хорошо", style: .default)
        addAction(reportButton)
    }
}

