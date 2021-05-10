import UIKit

final class OfflineTaskPresenter: OfflineTaskViewPresenter {
    func addTask(_ task: OfflineTask, in indexPath: IndexPath) {
        let section = indexPath.section
        RealmBase.addTask(task, in: section)
    }
    
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath) {
        RealmBase.changeTask(task, indexPath: indexPath)
    }
}
