import Foundation

class Group {
    var name: String
    var image: String
    var owners: [Owners]
    
    init(name: String, image: String, owners: [Owners]) {
        self.name = name
        self.image = image
        self.owners = owners
    }
    
    init() {
        self.name = ""
        self.image = ""
        self.owners = [Owners]()
    }
}

class Owners {
    var owner: String
    var image: String
    var tasks: [Task]
    
    init(owner: String, image: String, tasks: [Task]) {
        self.owner = owner
        self.image = image
        self.tasks = tasks
    }
}

class Task {
    var owner: String
    var name: String
    var description: String
    var date: Date
    var isDone: Bool = false
    
    init(owner: String, name: String, description: String, date: Date) {
        self.owner = owner
        self.name = name
        self.description = description
        self.date = date
    }
}
