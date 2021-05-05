import UIKit

final class OfflineTaskTableViewCell: TaskTableViewCell {
    func setUp(with task: Task) {
        taskLabel.text = task.name
    }
}
