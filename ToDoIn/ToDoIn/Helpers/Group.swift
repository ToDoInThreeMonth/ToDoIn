import Foundation

struct Group: Equatable {
    
    var id: String
    var title: String
    var image: String
    var users: [String]
    var tasks: [Task]
    
    init(id: String = "", title: String = "", image: String = "default", tasks: [Task] = [], users: [String] = []) {
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
    var email: String
    var image: String
    var friends: [String]
    
    init(id: String = "", name: String = "", email: String = "", image: String = "default", friends: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.image = image
        self.friends = friends
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
    
    init(id: String = UUID().description, userId: String = "", title: String = "", description: String = "", date: Date = Date(), isDone: Bool = false) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.date = date
        self.isDone = isDone
    }
}
