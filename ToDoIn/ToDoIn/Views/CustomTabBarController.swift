import UIKit
import PinLayout

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let buttonView = UIView()
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Изменение TabBar'а
        let tabBar = { () -> CustomTabBar in
            let tabBar = CustomTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        
        self.delegate = self
        self.selectedIndex = 0
        
        // Кнопка главная
        button.setBackgroundImage(UIImage(named: "main"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.tabBar.addSubview(button)
        
        button.addTarget(self, action: #selector(accountButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
        button.pin.bottomCenter(view.pin.safeArea.bottom).size(CGSize(width: 90, height: 90))
    }
    

    @objc func accountButtonAction(sender: UIButton) {
        self.selectedIndex = 1
    }
    
}
