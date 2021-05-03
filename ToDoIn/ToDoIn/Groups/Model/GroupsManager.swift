import Foundation
import FirebaseFirestore

enum NetworkError: Error {
    case unexpected
}

protocol GroupsManagerDescription {
    func observeGroups(completion: @escaping (Result<[Group], Error>) -> Void)
    func observeGroup(by userId: String, completion: @escaping (Result<Group, Error>) -> Void)
    
    func getTasks(for userId: String, from group: Group) -> [Task]
    func getUser(by userId: String, completion: @escaping (Result<User, Error>) -> Void)
    
    func addTask(_ task: Task, in group: Group)
}

final class GroupsManager: GroupsManagerDescription {
    static let shared: GroupsManagerDescription = GroupsManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func observeGroups(completion: @escaping (Result<[Group], Error>) -> Void) {
        database.collection("groups").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            let groups = documents.compactMap { GroupsConverter.group(from: $0) }
            completion(.success(groups))
        }
    }
    
    func observeGroup(by userId: String, completion: @escaping (Result<Group, Error>) -> Void) {
        database.collection("groups").document(userId).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = querySnapshot else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            let group = GroupsConverter.group(from: data) ?? Group()
            completion(.success(group))
        }
    }
    
    func getTasks(for userId: String, from group: Group) -> [Task] {
        var tasks = [Task]()
        for task in group.tasks {
            if userId == task.userId {
                tasks.append(task)
            }
        }
        return tasks
    }
    
    func getUser(by userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let docRef = database.collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            
            let user = GroupsConverter.user(from: data)
            completion(.success(user))
        }
    }
    
    func addTask(_ task: Task, in group: Group) {
        var tasks = [GroupsConverter.task(from: task)]
        for task in group.tasks {
            tasks.append(GroupsConverter.task(from: task))
        }
        database.collection("groups").document(group.id).setData(["tasks": tasks], merge: true)
    }
}

private final class GroupsConverter {
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
        case image
    }
    
    static func group(from document: DocumentSnapshot) -> Group? {
        guard
            let dict = document.data(),
            let title = dict[GroupKey.title.rawValue] as? String
        else {
            return nil
        }
        
        let image = dict[GroupKey.image.rawValue] as? String ?? ""
        
        // USERS
        let users = dict[GroupKey.users.rawValue] as? [String] ?? [String]()
        
        // TASKS
        var tasks = [Task]()
        let tasksArray = dict[GroupKey.tasks.rawValue] as? [Any]
        if let tasksArray = tasksArray {
            for task in tasksArray {
                guard let task = task as? [String : Any] else {
                    break
                }
                tasks.append(self.task(from: task))
            }
        }
        let group = Group(id: document.documentID, title: title, image: image, tasks: tasks, users: users)
        return group
    }
    
    static func task(from task: [String : Any]) -> Task {
        guard
            let id = task[TaskKey.id.rawValue] as? String,
            let userId = task[TaskKey.userId.rawValue] as? String,
            let title = task[TaskKey.title.rawValue] as? String,
            let description = task[TaskKey.description.rawValue] as? String,
            let date = task[TaskKey.date.rawValue] as? Timestamp,
            let isDone = task[TaskKey.isDone.rawValue] as? Bool
        else {
            return Task()
        }
        return Task(id: id, userId: userId, title: title, description: description, date: date.dateValue(), isDone: isDone)
    }
    
    static func user(from user: [String : Any]) -> User {
        guard
            let id = user[UserKey.id.rawValue] as? String,
            let name = user[UserKey.name.rawValue] as? String,
            let image = user[UserKey.image.rawValue] as? String
        else {
            return User()
        }
        return User(id: id, name: name, image: image)
    }
    
    static func task(from task: Task) -> Dictionary<String, Any> {
        var res = [String : Any]()
        res[TaskKey.id.rawValue] = task.id
        res[TaskKey.title.rawValue] = task.title
        res[TaskKey.description.rawValue] = task.description
        res[TaskKey.date.rawValue] = Timestamp(date: task.date)
        res[TaskKey.userId.rawValue] = task.userId
        res[TaskKey.isDone.rawValue] = task.isDone
        return res
    }
}
