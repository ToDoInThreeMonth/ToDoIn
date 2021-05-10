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
    
    private lazy var authView: AuthView = {
        let view = AuthView(frame: .zero)
        view.delegate = self
        return view
    }()
    
    private var isAuth = false
    
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
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
    }
    
    // UI configure methods
    private func setupViews() {
        view.backgroundColor = .accentColor
        view.addSubviews(tableView,
                         authView)
    }
    
    private func setupLayouts() {
        authView.pin
            .bottom(view.pin.safeArea.bottom)
            .horizontally(10)
            .height(250)
            .marginBottom(-20)
        
        if isAuth {
            tableView.pin
                .top()
                .horizontally()
                .bottom()
                .marginTop(20)
                .marginBottom(10)
            
        } else {
            tableView.pin
                .top(view.pin.safeArea.top)
                .horizontally()
                .bottom(to: authView.edge.top)
                .marginTop(20)
                .marginBottom(10)
        }
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .main, for: self)
        
        navigationItem.rightBarButtonItem?.action = #selector(addSectionButtonTapped)
        navigationItem.rightBarButtonItem?.target = self
    }
    
    private func changeSizeTableView() {
        isAuth.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.setupLayouts()
        }
    }
    
    private func hiddenAuthView() {
        authView.isHidden = true
    }
    
    @objc
    private func addSectionButtonTapped() {
        presenter?.showAddSectionController()
    }
}

extension MainViewController: MainTableViewOutput {
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
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}

extension MainViewController: AuthViewOutput {
    func authButtonTapped() {
        hiddenAuthView()
        changeSizeTableView()
    }
}

extension MainViewController: SectionAlertDelegate {
    func addNewSection(with text: String) {
        presenter?.addNewSection(with: text)
        updateUI()
    }
}

extension MainViewController: DeleteAlertDelegate {
    func deleteSection(_ number: Int) {
        presenter?.deleteSection(number)
        updateUI()
    }
}
