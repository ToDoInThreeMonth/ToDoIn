import Foundation

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
