import UIKit

final class MainProgressTableHeaderView: UITableViewHeaderFooterView {
    private var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Прогресс 0%"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var progressView: UIProgressView = {
        let progressView = GradientProgressView(leftColor: .leftProgressColor, rightColor: .rightProgressColor)
        progressView.setProgress(0.75, animated: false)
        return progressView
    }()
    
    struct LayoutConstraints {
        static let cellHeight: CGFloat = 40
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        configureViews()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        return CGSize(width: contentView.frame.width, height: LayoutConstraints.cellHeight)
    }
    
    private func setupViews() {
        contentView.addSubviews(progressLabel,
                                progressView)
    }
    
    private func setupLayouts() {
        progressLabel.pin
            .top(5)
            .horizontally(30)
            .sizeToFit(.width)
        progressView.pin
            .top(to: progressLabel.edge.bottom)
            .marginTop(10)
            .bottom(10)
            .horizontally(30)
    }
    
    private func configureViews() {
        if progressView.layer.cornerRadius == 0 {
            progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
            
            // Добавляем градиентный image
            let gradientImage = UIImage.gradientImage(with: progressView.frame,
                                                      colors: [UIColor.leftProgressColor.cgColor,
                                                               UIColor.rightProgressColor.cgColor])
            progressView.progressImage = gradientImage
            // Делаем закругления
            for subview in progressView.subviews {
                if let imageView = subview as? UIImageView {
                    imageView.layer.cornerRadius = progressView.frame.height / 2
                    imageView.clipsToBounds = true
                }
            }
        }
    }
    
    func setProgress(is progress: Float) {
        let procentProgress = Int(progress * 100)
        progressLabel.text = "Прогресс \(procentProgress)%"
        progressView.setProgress(progress, animated: true)
    }
}
