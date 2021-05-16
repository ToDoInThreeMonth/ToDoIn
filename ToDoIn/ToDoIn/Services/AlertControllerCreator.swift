import UIKit

// Alert Controllers factory
struct AlertControllerCreator {
    // Nested data types
    enum TypeAlert {
        case logOut
        case error
        case delete
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
        case .delete:
            let alertController = ExitAlertController(title: title, message: message, preferredStyle: .alert)
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
        let reportButton = UIAlertAction(title: "Сообщить об ошибке", style: .default) { /* [unowned self] */ _ in 
            print("Заглушка")
        }
        addAction(reportButton)
    }
}
