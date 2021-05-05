import UIKit
import PinLayout

class MainController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: MainViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        
    }
    
}

extension MainController: MainView {
    func setPresenter(presenter: MainViewPresenter, coordinator: MainChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}

