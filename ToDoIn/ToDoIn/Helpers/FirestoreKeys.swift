import Foundation

enum Collection: String {
    case groups
    case users
}

enum GroupKey: String {
    case id
    case title
    case image
    case users
    case tasks
}

enum TaskKey: String {
    case id
    case userId
    case title
    case description
    case date
    case isDone
}

enum UserKey: String {
    case id
    case name
    case email
    case image
    case friends
}
