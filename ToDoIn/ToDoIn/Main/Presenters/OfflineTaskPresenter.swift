import UIKit

final class OfflineTaskPresenter: OfflineTaskViewPresenter {
    private var dataBase: MainFrameRealmProtocol?
    
    func setRealmOutput(_ output: mainFrameRealmOutput) {
        let base = MainFrameRealm(output: output)
        dataBase = base
    }
    
    func addTask(_ task: OfflineTask, in indexPath: IndexPath) {
        guard let dataBase = dataBase else { return }
        let section = indexPath.section
        dataBase.addTask(task, in: section)
    }
    
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath) {
        guard let dataBase = dataBase else { return }
        dataBase.changeTask(task, indexPath: indexPath)
    }
}
