import UIKit
import PinLayout

class AccountViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "nlo")
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    private lazy var userDownView: UIView = UIView()
    private lazy var userUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240 / 255, green: 238 / 255, blue: 239 / 255, alpha: 1)
        return view
    }()

    private lazy var userUpNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Неопознанный объект"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
        return label
    }()
    
    private lazy var userDownNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь ToDoIn"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1)
        return label
    }()
    
    private lazy var friendsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: String(describing: AccountTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 243 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        view.addSubviews(userDownView, userUpNameLabel, userDownNameLabel, friendsTableView)
        userDownView.addSubviews(userUpView, userImageView)
        
    }

    private func setupLayouts() {
        userDownView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
            .size(CGSize(width: 150, height: 150))
        userUpView.pin.all()
        userImageView.pin
            .all().margin(20)
        userUpNameLabel.pin
            .top(to: userDownView.edge.bottom)
            .hCenter()
            .marginTop(20)
            .sizeToFit()
        userDownNameLabel.pin
            .top(to: userUpNameLabel.edge.bottom)
            .hCenter()
            .sizeToFit()
        friendsTableView.pin
            .top(to: userDownNameLabel.edge.bottom)
            .start(50)
            .end(50)
            .bottom(20)
            .marginTop(20)
        
        userImageView.makeRound()
        userUpView.makeRound()
        userDownView.setShadowWithColor(color: .black, alpha: 0.15, x: 10, y: 10, blur: 10, cornerRadius: userUpView.layer.cornerRadius)
        userDownView.setShadowWithColor(color: .white, alpha: 0.5, x: -10, y: -10, blur: 10, cornerRadius: userUpView.layer.cornerRadius)
        userUpView.addInnerShadowWithColor(color: .white, alpha: 0.7, x: 10, y: 10, blur: 5, cornerRadius: userUpView.layer.cornerRadius)
        userImageView.addInnerShadowWithColor(color: .white, alpha: 0.7, x: -5, y: -5, blur: 6, cornerRadius: userImageView.layer.cornerRadius)
    }

}

//MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountTableViewCell.self), for: indexPath) as! AccountTableViewCell
        cell.textLabel?.text = "111111"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Друзья"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

extension AccountViewController: UITableViewDelegate {

}
