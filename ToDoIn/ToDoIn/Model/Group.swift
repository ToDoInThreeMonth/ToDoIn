import Foundation

class Group {
    var name: String
    var image: String
    var tasks: [Task]
    
    init(name: String, image: String, tasks: [Task]) {
        self.name = name
        self.image = image
        self.tasks = tasks
    }
}
