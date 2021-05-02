import Foundation

struct Group: Equatable {
    
    var id: String
    var title: String
    var image: String
    var users: [String]
    var tasks: [Task]
    
    init(id: String = "", title: String = "", image: String = "", tasks: [Task] = [Task](), users: [String] = [String]()) {
        self.id = id
        self.title = title
        self.image = image
        self.users = users
        self.tasks = tasks
    }

    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}

struct User: Equatable {
    var id: String
    var name: String
    var image: String
    
    init(id: String = "", name: String = "", image: String = "user") {
        self.id = id
        self.name = name
        self.image = image
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Task {
    var id: String
    var userId: String
    var title: String
    var description: String
    var date: Date
    var isDone: Bool
    
    init(id: String = "", userId: String = "", title: String = "", description: String = "", date: Date = Date(), isDone: Bool = false) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.date = date
        self.isDone = isDone
    }
}
