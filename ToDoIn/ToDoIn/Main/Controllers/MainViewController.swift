//
//  ViewController.swift
//  ToDoIn
//
//  Created by Дарья on 24.03.2021.
//

import UIKit
import PinLayout

class MainViewController: UIViewController {
    // Private stored properties
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
    
//    private lazy var authView: AuthView = {
//        let view = AuthView(frame: .zero)
//        view.delegate = self
//        return view
//    }()
    
//    Если будут онлайн секции - это проверка на регистрацию
//    private var isAuth = false
    
    // Initializers
    init(presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ViewController lifecycle methods
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
    
    // UI configure methods
    private func setupViews() {
        view.backgroundColor = .accentColor
        view.addSubviews(tableView,
//                         authView,
                         addSectionButton)
    }
    
    private func setupLayouts() {
//  Вьюха регистрации
//        authView.pin
//            .bottom(view.pin.safeArea.bottom)
//            .horizontally(10)
//            .height(230)
//            .marginBottom(-40)
        
//        if isAuth {
            addSectionButton.pin
                .bottom(view.pin.safeArea.bottom)
                .horizontally(30)
                .height(40)
                .marginBottom(10)
            tableView.pin
                .top(view.pin.safeArea.top)
                .horizontally()
                .bottom(to: addSectionButton.edge.top)
                .marginTop(10)
                .marginBottom(10)
//        } else {
//            addSectionButton.pin
//                .bottom(to: authView.edge.top)
//                .horizontally(30)
//                .height(40)
//                .marginBottom(10)
//            tableView.pin
//                .top(view.pin.safeArea.top)
//                .horizontally()
//                .bottom(to: addSectionButton.edge.top)
//                .marginTop(10)
//                .marginBottom(10)
//        }
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
    
//    private func changeSizeTableView() {
//        isAuth.toggle()
//
//        UIView.animate(withDuration: 0.3) {
//            self.setupLayouts()
//        }
//    }
    
//    private func hiddenAuthView() {
//        authView.isHidden = true
//    }
    
    @objc
    private func addSectionButtonTapped() {
        presenter?.showAddSectionController()
    }
}

extension MainViewController: MainTableViewOutput {
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
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getNumberOfRows(in: section)
    }
    
    func getTask(from indexPath: IndexPath) -> OfflineTask? {
        guard let presenter = presenter else { return nil }
        return presenter.getTask(from: indexPath)
    }
    
    
    func cellDidSelect(in indexPath: IndexPath) {
        presenter?.showChangeTaskController(with: indexPath)
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

//MARK: - AuthViewOutput
//extension MainViewController: AuthViewOutput {
//    func authButtonTapped() {
//        hiddenAuthView()
//        changeSizeTableView()
//    }
//}

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
