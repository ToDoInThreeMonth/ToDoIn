import Foundation

struct Group: Equatable {
    
    var id: UUID
    var name: String
    var image: String
    var users: [User]
    var tasks: [Task]
    
    init(id: UUID = UUID(), name: String = "", image: String = "", tasks: [Task] = [Task](), users: [User] = [User]()) {
        self.id = id
        self.name = name
        self.image = image
        self.users = users
        self.tasks = tasks
    }

    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}

struct User: Equatable {
    var id: UUID
    var name: String
    var image: String
    
    init(id: UUID = UUID(), name: String = "", image: String = "") {
        self.id = id
        self.name = name
        self.image = image
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Task {
    var user: User
    var name: String
    var description: String
    var date: Date
    var isDone: Bool = false
    
    init(user: User = User(), name: String = "", description: String = "", date: Date = Date()) {
        self.user = user
        self.name = name
        self.description = description
        self.date = date
    }
}
