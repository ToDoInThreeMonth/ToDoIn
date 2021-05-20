import UIKit

class OfflineTaskController: TaskController {
    // Private stored properties
    private var presenter: OfflineTaskViewPresenter?
    private var indexPath: IndexPath
    private var isChanging: Bool
    weak var delegate: MainTableViewOutput?
    
    init(task: OfflineTask = OfflineTask(),indexPath: IndexPath, isChanging: Bool = false, presenter: OfflineTaskViewPresenter) {
        let onlineTask = Task(user: User(), name: task.title, description: task.descriptionText, date: task.date)
        self.indexPath = indexPath
        self.presenter = presenter
        self.isChanging = isChanging
        super.init(group: Group(), task: onlineTask, isChanging: isChanging)
        hiddenUserTF()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    override func addButtonTapped() {
        let task = getTask()
        if isChanging {
            presenter?.changeTask(task, in: indexPath)
        } else {
            presenter?.addTask(task, in: indexPath)
        }
        dismiss(animated: true, completion: nil)
    }
    

    
}
