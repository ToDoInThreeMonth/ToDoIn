import UIKit
import PinLayout

protocol MainTableViewOutput: class {
    func showChangeSectionController(with section: Int)
    func getProgress() -> Float
    func showAddTaskController(with section: Int)
    func cellDidSelect(in indexPath: IndexPath, isArchive: Bool)
    func doneViewTapped(with indexPath: IndexPath)
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int
    func getTask(from indexPath: IndexPath, isArchive: Bool) -> OfflineTask?
    func showDeleteSectionController(_ number: Int)
    func getArchiveSection() -> ArchiveSection?
    func deleteTask(section: Int, row: Int, isArchive: Bool)
}

protocol mainFrameRealmOutput: class {
    func updateUI()
}

protocol AddSectionAlertDelegate: class {
    func addNewSection(with text: String)
}

protocol ChangeSectionAlertDelegate: class {
    func changeSection(with number: Int, text: String)
}

protocol DeleteAlertDelegate: class {
    func deleteSection(_ number: Int)
}

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: MainViewPresenter?
    
    private lazy var mainTVDelegate = MainTVDelegate(controller: self)
    private lazy var mainTVDataSource = MainTVDataSource(controller: self)
    private lazy var tableView: UITableView = {
        let tableView = MainTableView(frame: .zero, style: .grouped)
        tableView.delegate = mainTVDelegate
        tableView.dataSource = mainTVDataSource
        tableView.register(OfflineTaskTableViewCell.self, forCellReuseIdentifier: String(describing: OfflineTaskTableViewCell.self))
        tableView.register(MainOfflineHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainOfflineHeaderView.self))
        return tableView
    }()
    
    private lazy var addSectionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus")
        button.setTitle("Добавить секцию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(image, for: .normal)
        button.tintColor = .darkTextColor
        button.addTarget(self, action: #selector(addSectionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setBackground()
        setupNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
        setupAddSectionButton()
    }
    
    // MARK: - Configures
    
    private func setupViews() {
        view.backgroundColor = .accentColor
        view.addSubviews(tableView,
                         addSectionButton)
    }
    
    private func setupLayouts() {
            addSectionButton.pin
                .bottom(view.pin.safeArea.bottom)
                .horizontally(30)
                .height(40)
                .marginBottom(45)
            tableView.pin
                .top(view.pin.safeArea.top)
                .horizontally()
                .bottom(to: addSectionButton.edge.top)
                .marginTop(10)
                .marginBottom(10)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .main, for: self)
    }
    
    private func setupAddSectionButton() {
        if addSectionButton.layer.cornerRadius == 0 {
            addSectionButton.layer.cornerRadius = 20
            addSectionButton.addDashBorder()
            
            addSectionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
    }
    
    // MARK: - Handlers
    
    @objc
    private func addSectionButtonTapped() {
        presenter?.showAddSectionController()
    }
}

// MARK: - Extensions

extension MainViewController: MainTableViewOutput {
    func deleteTask(section: Int, row: Int, isArchive: Bool) {
        presenter?.deleteTask(section: section, row: row, isArchive: isArchive)
    }
    
    func getArchiveSection() -> ArchiveSection? {
        return presenter?.getArchiveSection()
    }
    func showChangeSectionController(with section: Int) {
        presenter?.showChangeSectionController(with: section)
    }
    
    func getProgress() -> Float {
        guard let presenter = presenter else { return 0 }
        return presenter.getProgress()
    }
    func showDeleteSectionController(_ number: Int) {
        presenter?.showDeleteSectionController(number)
    }
    
    func getAllSections() -> [OfflineSection] {
        guard let presenter = presenter else { return [] }
        return presenter.getAllSections()
    }
    
    func getNumberOfSections() -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getNumberOfSections()
    }
    
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getNumberOfRows(in: section, isArchive: isArchive)
    }
    
    func getTask(from indexPath: IndexPath, isArchive: Bool) -> OfflineTask? {
        guard let presenter = presenter else { return nil }
        return presenter.getTask(from: indexPath, isArchive: isArchive)
    }
    
    
    func cellDidSelect(in indexPath: IndexPath, isArchive: Bool) {
        presenter?.showChangeTaskController(with: indexPath, isArchive: isArchive)
    }
    
    func showAddTaskController(with section: Int) {
        presenter?.showAddTaskController(with: section)
    }
    
    func doneViewTapped(with indexPath: IndexPath) {
        presenter?.taskComplete(with: indexPath)
    }
}

extension MainViewController: mainFrameRealmOutput {
    func updateUI() {
        tableView.reloadData()
    }
}

//MARK: - SectionAlertDelegate

extension MainViewController: AddSectionAlertDelegate {
    func addNewSection(with text: String) {
        presenter?.addNewSection(with: text)
    }
}

//MARK: - DeleteAlertDelegate

extension MainViewController: DeleteAlertDelegate {
    func deleteSection(_ number: Int) {
        presenter?.deleteSection(number)
    }
}
