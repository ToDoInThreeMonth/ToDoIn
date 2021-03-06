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

// MARK: - Friends TableViewDataSource
class MainTVDataSource: NSObject, UITableViewDataSource {
    private weak var controller: MainTableViewOutput?
    
    init(controller: MainTableViewOutput) {
        self.controller = controller
    }
    
    // Создание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let controller = controller,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfflineTaskTableViewCell.self), for: indexPath) as? OfflineTaskTableViewCell
        else { return UITableViewCell() }
        let sectionCount = controller.getNumberOfSections()
        
        switch indexPath.section {
        case sectionCount:
            guard let task = controller.getTask(from: indexPath, isArchive: true)
            else { return UITableViewCell() }
            cell.setUp(with: task, isArchive: true)
            return cell
        case 1..<sectionCount:
            guard let task = controller.getTask(from: indexPath, isArchive: false)
            else { return UITableViewCell() }
            cell.setUp(with: task, isArchive: false)
            cell.index = indexPath
            cell.delegate = controller
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let controller = controller else { return 0 }
        // +1 секция - это секция с прогрессом
        return controller.getNumberOfSections() + 1
    }
    
    // Количестве ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        let sectionCount = controller.getNumberOfSections()
        switch section {
        case 0:
            return 0
            // Последняя секция - всегда архив
        case sectionCount:
            return controller.getNumberOfRows(in: section, isArchive: true)
            // Оффлайн секции
        case 0..<sectionCount:
            return controller.getNumberOfRows(in: section, isArchive: false)
        default:
           return 0
        }
        
    }
}

// MARK: - Friends TableViewDelegate
class MainTVDelegate: NSObject, UITableViewDelegate {
    private weak var controller: MainTableViewOutput?
    
    init(controller: MainTableViewOutput) {
        self.controller = controller
    }
    
    // Хедеры секций
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let controller = controller else { return nil }
        let sectionCount = controller.getNumberOfSections()
        
        switch section {
        case 0:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainProgressTableHeaderView.self)) as? MainProgressTableHeaderView
            else { return nil }
            let progress = controller.getProgress()
            headerView.setProgress(is: progress)
            return headerView
        case sectionCount:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView,
                  let sectionName = controller.getArchiveSection()?.name
            else { return nil}
           
            headerView.setupArchiveState()
            headerView.sectionName = sectionName
            return headerView
        case 0..<sectionCount:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainOfflineHeaderView.self)) as? MainOfflineHeaderView
            else { return nil}
            
            headerView.delegate = controller
            headerView.section = section
            
            let sectionName = controller.getAllSections()[section - 1].name
            headerView.sectionName = sectionName
            return headerView
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = controller else { return }
        let sectionCount = controller.getNumberOfSections()
        
        switch indexPath.section {
        case 1...sectionCount:
            controller.cellDidSelect(in: indexPath, isArchive: indexPath.section == sectionCount ? true : false)
        default:
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
}
