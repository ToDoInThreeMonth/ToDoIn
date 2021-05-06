import UIKit

class AuthView: UIView {
    weak var delegate: AuthViewOutput?
    
    private lazy var authLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.darkTextColor.withAlphaComponent(0.7)
        label.text = "Войдите в аккаунт, чтобы увидеть задачи из совместных комнат"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Авторизоваться", for: .normal)
        button.tintColor = .darkTextColor
        button.backgroundColor = .accentColor
        button.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var translucentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dolphinImageView = UIImageView(image: UIImage(named: "dolphinBlur"))
    
    struct LayersConstants {
        static let authHeight: CGFloat = 40
        static let verticalOffset: CGFloat = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupShadows()
    }
    
    private func setupViews() {
        addSubviews(authLabel,
                    authButton,
                    dolphinImageView,
                    translucentView)
    }
    
    private func setupLayouts() {
        authLabel.pin
            .top()
            .horizontally()
            .height(LayersConstants.authHeight)
        authButton.pin
            .top(to: authLabel.edge.bottom)
            .height(LayersConstants.authHeight)
            .width(bounds.width * 0.5)
            .hCenter()
            .marginTop(LayersConstants.verticalOffset)
        translucentView.pin
            .top(to: authButton.edge.bottom)
            .height(bounds.height - 2 * (LayersConstants.authHeight + LayersConstants.verticalOffset))
            .horizontally()
            .bottom()
            .marginTop(LayersConstants.verticalOffset)
        dolphinImageView.pin
            .width(translucentView.bounds.width / 2)
            .height(translucentView.bounds.height / 2)
            .center(to: translucentView.anchor.center)
            
    }
    
    private func setupShadows() {
        if authButton.layer.cornerRadius == 0 {
            authButton.layer.cornerRadius = 20
            authButton.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
            authButton.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
            authButton.addLinearGradiend()
        }
    }
    
    @objc
    private func authButtonTapped() {
        delegate?.authButtonTapped()
    }
}
