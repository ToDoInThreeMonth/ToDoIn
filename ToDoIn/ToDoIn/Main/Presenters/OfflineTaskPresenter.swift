import UIKit

final class OfflineTaskPresenter: OfflineTaskViewPresenter {
    private var realmBase: MainFrameRealmProtocol = MainFrameRealm.shared
    
    func addTask(_ task: OfflineTask, in indexPath: IndexPath) {
        let section = indexPath.section
        realmBase.addTask(task, in: section)
    }
    
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath) {
        realmBase.changeTask(task, indexPath: indexPath)
    }
}
