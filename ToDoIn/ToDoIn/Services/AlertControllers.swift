import UIKit

struct AlertControllerCreator {
    enum TypeAlert {
        case logOut
        case error
    }
    
    static func getController (title: String?, message: String?, style: UIAlertController.Style, type: TypeAlert) -> UIAlertController {
        switch type {
        case .logOut:
            let alertController = LogOutAlertController(title: title, message: message, preferredStyle: style)
            return alertController
        case .error:
            let alertController = ErrorAlertController(title: title, message: message, preferredStyle: .alert)
            return alertController
        }
    }
}

class LogOutAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupButton() {
        let agreeButton = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Да", style: .destructive) {[unowned self] _ in
            print("Выход сработал")
        }
        addAction(disagreeButton)
        addAction(agreeButton)
    }
}

class ErrorAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupButton() {
        let reportButton = UIAlertAction(title: "Сообщить об ошибке", style: .default) { [weak self] _ in
            print(self?.message)
        }
        addAction(reportButton)
    }
}
