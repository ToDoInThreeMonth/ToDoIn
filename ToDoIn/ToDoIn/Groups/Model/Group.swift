import Foundation

class Group: Equatable {
    
    var id = UUID()
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

    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}

class User: Equatable {
    var id = UUID()
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
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
    
    init() {
        self.user = User(name: "", image: "")
        self.name = ""
        self.description = ""
        self.date = Date()
    }
}
