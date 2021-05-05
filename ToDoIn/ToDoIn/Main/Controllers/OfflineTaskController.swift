import UIKit

class OfflineTaskController: TaskController {
    init(task: Task = Task(),isChanging: Bool = false) {
        super.init(group: Group(), task: task, isChanging: isChanging)
        hiddenUserTF()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
