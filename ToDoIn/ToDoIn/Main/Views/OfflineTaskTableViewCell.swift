import UIKit

final class OfflineTaskTableViewCell: TaskTableViewCell {
    func setUp(with task: OfflineTaskProtocol) {
        taskLabel.text = task.title
        
    }
}
