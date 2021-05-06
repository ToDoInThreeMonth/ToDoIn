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
    
    // Создание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfflineTaskTableViewCell.self), for: indexPath) as? OfflineTaskTableViewCell
        cell?.contentView.isUserInteractionEnabled = true
        guard let controller = controller else {
            return UITableViewCell()
        }
        guard let safeCell = cell else {
//            controller.showErrorAlertController(with: "Ячейки c задачами не могут быть созданы")
            return UITableViewCell()
        }
        
        guard let task = controller.getTask(from: indexPath) else { return UITableViewCell() }
        safeCell.setUp(with: task)
        return safeCell
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let controller = controller else { return 0 }
        return controller.getNumberOfSections()
    }
    
    // Количестве ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        return controller.getNumberOfRows(in: section)
    }
}

//MARK: - Friends TableViewDelegate
class MainTVDelegate: NSObject, UITableViewDelegate {
    private weak var controller: MainTableViewOutput?
    
    init(controller: MainTableViewOutput) {
        self.controller = controller
    }
    
    // Хедеры секций
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
        guard let saveHeaderView = headerView else { return nil }
        guard let controller = controller else { return nil }
        saveHeaderView.delegate = controller
        
        let sectionName = controller.getAllSections()[section].name
        saveHeaderView.sectionName = sectionName
        return saveHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.cellDidSelect(with: indexPath)
    }
    
    
}
