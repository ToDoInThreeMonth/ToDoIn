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
    
    private lazy var mainTVDelegate = MainTVDelegate()
    private lazy var mainTVDataSource = MainTVDataSource(controller: self)
    private lazy var tableView: UITableView = {
        let tableView = MainTableView(frame: .zero, style: .plain)
        tableView.delegate = mainTVDelegate
        tableView.dataSource = mainTVDataSource
        tableView.register(OfflineTaskTableViewCell.self, forCellReuseIdentifier: String(describing: OfflineTaskTableViewCell.self))
        tableView.register(MainOfflineHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainOfflineHeaderView.self))
        return tableView
    }()
    
    private lazy var authView = AuthView(frame: .zero)
    
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
            .height(300)
            .marginBottom(-20)
        tableView.pin
            .top(10)
            .horizontally()
            .bottom(to: authView.edge.top)
            .marginBottom(10)
    }
    
    private func setupNavigationItem() {
        navigationController?.configureBarButtonItems(screen: .main, for: self)
        
        navigationItem.rightBarButtonItem?.action = #selector(addTaskButtonTapped)
        navigationItem.rightBarButtonItem?.target = self
    }
    
    @objc
    private func addTaskButtonTapped() {
        presenter?.showAddTaskController()
    }
}

extension MainViewController: MainTableViewOutput {
    var tasks: [OfflineTaskProtocol] {
        return []
    }
    
    func showErrorAlertController(with message: String) {
        
    }
}
