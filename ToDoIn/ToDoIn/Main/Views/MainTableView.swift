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
        register(MainProgressTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MainProgressTableHeaderView.self))
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
        guard let controller = controller,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfflineTaskTableViewCell.self), for: indexPath) as? OfflineTaskTableViewCell,
              let task = controller.getTask(from: indexPath)
        else { return UITableViewCell() }

        cell.setUp(with: task)
        cell.index = indexPath
        cell.delegate = controller
        
        return cell
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let controller = controller else { return 0 }
        return controller.getNumberOfSections()
    }
    
    // Количестве ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        switch section {
        case 0:
            return 0
        default:
            return controller.getNumberOfRows(in: section)
        }
        
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
        switch section {
        case 0:
            guard let controller = controller,
                  let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainProgressTableHeaderView.self)) as? MainProgressTableHeaderView else { return nil }
            let progress = controller.getProgress()
            headerView.setProgress(is: progress)
            return headerView
        default:
            guard let controller = controller,
                  let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
            else { return nil}
            
            headerView.delegate = controller
            headerView.section = section
            
            let sectionName = controller.getAllSections()[section].name
            headerView.sectionName = sectionName
            return headerView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.cellDidSelect(in: indexPath)
    }
}
