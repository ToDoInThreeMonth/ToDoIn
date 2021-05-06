import UIKit

class OfflineTaskController: TaskController {
    init(task: OfflineTask = OfflineTask(),isChanging: Bool = false) {
        let onlineTask = Task(user: User(), name: task.title, description: task.descriptionText, date: task.date)
        super.init(group: Group(), task: onlineTask, isChanging: isChanging)
        hiddenUserTF()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
