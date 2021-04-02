//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 31.03.2021.
//

import UIKit
import PinLayout

class GroupsController: UIViewController {
    
    var groups = [Group(name: "Дача", image: "group"), Group(name: "Шашлыки", image: "group"), Group(name: "Дача", image: "group"), Group(name: "Шашлыки", image: "group")]
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        tableView.pin.all()
    }
    
    func configureTableView() {
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 110
    }

}


extension GroupsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        cell.backgroundColor = .white
        cell.tintColor = .white
        cell.setUp(group: groups[indexPath.row])
        return cell
    }
    
}
