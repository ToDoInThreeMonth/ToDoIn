import UIKit

class OfflineTaskController: TaskController {
    // Private stored properties
    private var presenter: OfflineTaskViewPresenter = OfflineTaskPresenter()
    private var indexPath: IndexPath
    private var isChanging: Bool
    weak var delegate: MainTableViewOutput?
    
    init(task: OfflineTask = OfflineTask(),indexPath: IndexPath, isChanging: Bool = false) {
        let onlineTask = Task(user: User(), name: task.title, description: task.descriptionText, date: task.date)
        self.indexPath = indexPath
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
        print(task)
        print(isChanging)
        if isChanging {
            presenter.changeTask(task, in: indexPath)
        } else {
            presenter.addTask(task, in: indexPath)
        }
        delegate?.updateUI()
        dismiss(animated: true, completion: nil)
    }
    
    
}
