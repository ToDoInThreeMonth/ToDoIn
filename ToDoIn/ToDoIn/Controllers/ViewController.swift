//
//  ViewController.swift
//  ToDoIn
//
//  Created by Дарья on 24.03.2021.
//

import UIKit
import PinLayout

class ViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?
    
    private lazy var offlineTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(MainOfflineTableViewCell.self, forCellReuseIdentifier: String(describing: MainOfflineTableViewCell.self))
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243, green: 247, blue: 250, alpha: 1)
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayouts()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupShadows()
    }
    
    private func setupViews() {
        view.addSubviews(offlineTableView)
    }
    
    private func setupLayouts() {
        offlineTableView.pin
            .top(view.pin.safeArea.top)
            .bottom(view.pin.safeArea.bottom)
            .horizontally(50)
            .marginVertical(30)
    
    }
    
    private func setupShadows() {
        
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainOfflineTableViewCell.self), for: indexPath) as! MainOfflineTableViewCell
//        cell.textLabel?.text = "123"
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

