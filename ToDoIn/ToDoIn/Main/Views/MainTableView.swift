import UIKit

import UIKit

class MainTableView: UITableView {
    // Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupCells()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI configure methods
    private func setupViews() {
        backgroundColor = UIColor.clear
        separatorStyle = .none
        allowsSelection = false
    }
    
    private func setupCells() {
        register(OfflineTaskTableViewCell.self, forCellReuseIdentifier: String(describing: OfflineTaskTableViewCell.self))
        register(MainOfflineHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainOfflineHeaderView.self))
    }
}

//MARK: - Friends TableViewDataSource
class MainTVDataSource: NSObject, UITableViewDataSource {
    private weak var controller: MainTableViewOutput?
    
    init(controller: MainTableViewOutput) {
        self.controller = controller
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfflineTaskTableViewCell.self), for: indexPath) as? OfflineTaskTableViewCell
        guard let controller = controller else {
            return UITableViewCell()
        }
        guard let safeCell = cell else {
            controller.showErrorAlertController(with: "Ячейки c задачами не могут быть созданы")
            return UITableViewCell()
        }
        
        let task = OfflineTasks.sections[indexPath.section].tasks[indexPath.row]
        safeCell.setUp(with: task)
        return safeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return OfflineTasks.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfflineTasks.sections[section].tasks.count
    }
   
}

//MARK: - Friends TableViewDelegate
class MainTVDelegate: NSObject, UITableViewDelegate {
    private weak var controller: MainTableViewOutput?
    
    init(controller: MainTableViewOutput) {
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
        guard let saveHeaderView = headerView else { return nil }
        let sectionName = OfflineTasks.sections[section].name
        saveHeaderView.sectionName = sectionName
        return saveHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Нажал")
        controller?.cellDidSelect(with: indexPath)
    }
}
