import Foundation

class Group {
    var name: String
    var image: String
    var users: [User]
    
    init(name: String, image: String, users: [User]) {
        self.name = name
        self.image = image
        self.users = users
    }
    
    init() {
        self.name = ""
        self.image = ""
        self.users = [User]()
    }
}

class User {
    var name: String
    var image: String
    var tasks: [Task]
    
    init(user: String, image: String, tasks: [Task]) {
        self.name = user
        self.image = image
        self.tasks = tasks
    }
}

class Task {
    var user: String
    var name: String
    var description: String
    var date: Date
    var isDone: Bool = false
    
    init(user: String, name: String, description: String, date: Date) {
        self.user = user
        self.name = name
        self.description = description
        self.date = date
    }
}
