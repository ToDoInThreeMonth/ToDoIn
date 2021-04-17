import Foundation

class Group {
    var name: String
    var image: String
    var users: [User]
    var tasks: [Task]
    
    init(name: String, image: String, tasks: [Task], users: [User]) {
        self.name = name
        self.image = image
        self.users = users
        self.tasks = tasks
    }
    
    init() {
        self.name = ""
        self.image = ""
        self.users = [User]()
        self.tasks = [Task]()
    }
}

class User {
    var id = UUID()
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    func isEqual(_ user: User) -> Bool {
        return user.id == self.id
    }
}

class Task {
    var user: User
    var name: String
    var description: String
    var date: Date
    var isDone: Bool = false
    
    init(user: User, name: String, description: String, date: Date) {
        self.user = user
        self.name = name
        self.description = description
        self.date = date
    }
}
