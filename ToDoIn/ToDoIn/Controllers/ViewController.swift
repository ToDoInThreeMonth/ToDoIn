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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        tableView.separatorStyle = .none
        tableView.register(MainOfflineTableViewCell.self, forCellReuseIdentifier: String(describing: MainOfflineTableViewCell.self))
        tableView.register(MainOfflineHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainOfflineHeaderView.self))
        return tableView
    }()
    
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
        button.backgroundColor = .darkAccentColor
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var translucentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "backgroundImage"))
    private let dolphinImageView = UIImageView(image: UIImage(named: "dolphinBlur"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkAccentColor
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
        view.addSubviews(backgroundImageView, dolphinImageView, offlineTableView, authLabel, authButton, translucentView)
    }
    
    private func setupLayouts() {
        backgroundImageView.pin
            .all()
        dolphinImageView.pin
            .size(CGSize(width: 150, height: 100))
            .hCenter()
            .bottom(view.pin.safeArea.bottom)
            .marginBottom(20)
        translucentView.pin
            .height(200)
            .horizontally(15)
            .bottom(-15)
        authButton.pin
            .bottom(to: translucentView.edge.top)
            .marginBottom(15)
            .hCenter()
            .size(CGSize(width: 230, height: 40))
        authLabel.pin
            .bottom(to: authButton.edge.top)
            .marginBottom(15)
            .horizontally(50)
            .sizeToFit(.width)
        offlineTableView.pin
            .top(view.pin.safeArea.top)
            .bottom(to: authLabel.edge.top)
            .horizontally(32)
            .marginBottom(20)
            .marginTop(15)
        
    }
    
    private func setupShadows() {
        authButton.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        authButton.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 2)
        authButton.addLinearGradiend()
        
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostModel.posts[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
        guard let saveHeaderView = headerView else { return nil }
        guard let sectionName = PostModel.posts[section].first?.group else { return nil }
        saveHeaderView.sectionName = sectionName
        return saveHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainOfflineTableViewCell.self), for: indexPath) as? MainOfflineTableViewCell
        guard let safeCell = cell else { return UITableViewCell() }
        safeCell.textLabel?.text = "123"
        return safeCell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MainOfflineTableViewCell else { return }
        cell.cellDidTapped()
    }
    
    
}
