import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .accentColor
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationBar.layer.shadowRadius = 2
        navigationBar.layer.shadowOpacity = 0.10
    }
}
