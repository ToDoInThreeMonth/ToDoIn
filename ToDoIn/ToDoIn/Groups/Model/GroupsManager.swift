import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol GroupsManagerDescription {
    func observeGroups(completion: @escaping (Result<[Group], СustomError>) -> Void)
    func observeGroup(by userId: String, completion: @escaping (Result<Group, СustomError>) -> Void)
    func observeUser(by userId: String?, completion: @escaping (Result<User, СustomError>) -> Void)
    func observeFriends(_ friends: [String], completion: @escaping (Result<[User], СustomError>) -> Void)
    
    func addGroup(title: String, users: [String], photo: UIImage?)
    func addFriend(friend: User)
    func addUser(_ user: User, to group: Group)
    func addUsers(_ users: [User], to group: Group)
    func addTask(_ task: Task, in group: Group)

    func getTasks(for userId: String, from group: Group) -> [Task]
    func getUser(userId: String, completion: @escaping (Result<User, СustomError>) -> Void)
    func getUser(email: String, completion: @escaping (Result<User, СustomError>) -> Void)
    
    func changeTask(_ task: Task, in group: Group, completion: @escaping (СustomError?) -> Void)
    
    func deleteTask(_ task: Task, in group: Group)
    func deleteGroup(_ group: Group, completion: @escaping (Error?) -> Void)
}

final class GroupsManager: GroupsManagerDescription {
    
    static let shared: GroupsManagerDescription = GroupsManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func observeGroups(completion: @escaping (Result<[Group], СustomError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(СustomError.noSignedUser))
            return
        }
        database.collection("groups").addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(СustomError.unexpected))
                return
            }
            var groups = [Group]()
            for document in documents {
                guard let group = GroupsConverter.group(from: document) else { continue }
                if group.users.contains(currentUserId) {
                    groups.append(group)
                }
            }
            completion(.success(groups))
        }
    }
    
    func observeGroup(by userId: String, completion: @escaping (Result<Group, СustomError>) -> Void) {
        database.collection("groups").document(userId).addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            
            guard let data = querySnapshot else {
                completion(.failure(СustomError.unexpected))
                return
            }
            
            let group = GroupsConverter.group(from: data) ?? Group()
            completion(.success(group))
        }
    }
    
    func observeUser(by userId: String?, completion: @escaping (Result<User, СustomError>) -> Void) {
        let saveUserId: String
        if userId == nil {
            saveUserId = Auth.auth().currentUser?.uid ?? ""
        } else {
            saveUserId = userId!
        }
        database.collection("users").document(saveUserId).addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            guard let data = snapshot?.data() else {
                completion(.failure(СustomError.unexpected))
                return
            }
            let user = GroupsConverter.user(from: data)
            completion(.success(user))
        }
    }
    
    
    func observeFriends(_ friends: [String], completion: @escaping (Result<[User], СustomError>) -> Void) {
        var res = [User]()
        for friendId in friends {
            self.database.collection("users").document(friendId).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    completion(.failure(СustomError.error))
                    return
                }
                guard let data = snapshot?.data() else {
                    completion(.failure(СustomError.unexpected))
                    return
                }
                res.append(GroupsConverter.user(from: data))
            }
        }
        completion(.success(res))
    }
    
    
    func addGroup(title: String, users: [String], photo: UIImage?) {
        let ref = database.collection("groups").document()
        let docId = ref.documentID
        var imageName: String = "default"
        ImagesManager.loadPhotoToStorage(id: docId, photo: photo) { (myResult) in
            switch myResult {
            case .success(let url):
                imageName = url.absoluteString
            case .failure(_):
                imageName = "default"
            }
            ref.setData(["id" : docId,
                        "title" : title,
                        "image" : imageName,
                        "tasks" : [],
                        "users" : users])
        }
    }
    
    
    func addFriend(friend: User) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        database.collection("users").document(userId).updateData(["friends" : FieldValue.arrayUnion([friend.id])])
    }
    
    func addUser(_ user: User, to group: Group) {
        database.collection("groups").document(group.id).setData(["users": FieldValue.arrayUnion([user.id])], merge: true)
    }
    
    func addUsers(_ users: [User], to group: Group) {
        var usersId = [String]()
        for user in users {
            usersId.append(user.id)
        }
        database.collection("groups").document(group.id).setData(["users": FieldValue.arrayUnion(usersId)], merge: true)
    }
    
    
    func getUser(userId: String, completion: @escaping (Result<User, СustomError>) -> Void) {
        let docRef = database.collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            guard let document = document,
                  document.exists,
                  let data = document.data() else {
                completion(.failure(СustomError.unexpected))
                return
            }
            
            let user = GroupsConverter.user(from: data)
            completion(.success(user))
        }
    }
    
    func getUser(email: String, completion: @escaping (Result<User, СustomError>) -> Void) {
        database.collection("users").getDocuments { (snapshot, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(СustomError.unexpected))
                return
            }
            for document in documents {
                guard let docEmail = document["email"] as? String else {
                    continue
                }
                if docEmail == email {
                   let user = GroupsConverter.user(from: document.data())
                    completion(.success(user))
                    return
                }
            }
            completion(.failure(СustomError.noUser))
        }
    }
    
    func addTask(_ task: Task, in group: Group) {
        var tasks = [GroupsConverter.task(from: task)]
        for task in group.tasks {
            tasks.append(GroupsConverter.task(from: task))
        }
        database.collection("groups").document(group.id).setData(["tasks": tasks], merge: true)
        
//        let dictTask = [GroupsConverter.task(from: task)]
//        database.collection("groups").document(group.id).setData(["tasks": FieldValue.arrayUnion([dictTask])], merge: true)
    }
    
    func changeTask(_ task: Task, in group: Group, completion: @escaping (СustomError?) -> Void) {
        var tasks = [GroupsConverter.task(from: task)]
        for el in group.tasks {
            if el.id != task.id {
                tasks.append(GroupsConverter.task(from: el))
            }
        }
        database.collection("groups").document(group.id).updateData([ "tasks": tasks ]) { err in
            if err != nil {
                completion(.unexpected)
            }
        }
    }
    
    func deleteTask(_ task: Task, in group: Group) {
        database.collection("groups").document(group.id).updateData([
            "tasks": FieldValue.arrayRemove([GroupsConverter.task(from: task)]),
        ])
    }
    
    func deleteGroup(_ group: Group, completion: @escaping (Error?) -> Void) {
        database.collection("groups").document(group.id).delete() { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
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
    
}

final class GroupsConverter {
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
            let email = user[UserKey.email.rawValue] as? String,
            let image = user[UserKey.image.rawValue] as? String,
            let friends = user[UserKey.friends.rawValue] as? [String]
        else {
            return User()
        }
        return User(id: id, name: name, email: email, image: image, friends: friends)
    }
    
    static func user(from user: User) -> Dictionary<String, Any> {
        var res = [String : Any]()
        res[UserKey.id.rawValue] = user.id
        res[UserKey.name.rawValue] = user.name
        res[UserKey.image.rawValue] = user.image
        res[UserKey.friends.rawValue] = user.friends
        return res
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
