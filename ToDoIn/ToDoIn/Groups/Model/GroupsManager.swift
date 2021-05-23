import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol GroupsManagerDescription {
    func observeGroups(completion: @escaping (Result<[Group], СustomError>) -> Void)
    func observeGroup(by userId: String, completion: @escaping (Result<Group, СustomError>) -> Void)
    func observeUser(by userId: String?, completion: @escaping (Result<User, СustomError>) -> Void)
    
    func addGroup(title: String, users: [String], photo: UIImage?, completion: @escaping (Error?) -> Void)
    func addFriend(friend: User)
    func addUsers(_ users: [User], to group: Group)
    func addTask(_ task: Task, in group: Group)

    func getGroups(completion: @escaping (Result<[Group], СustomError>) -> Void)
    func getTasks(for userId: String, from group: Group) -> [Task]
    func getUser(userId: String, completion: @escaping (Result<User, СustomError>) -> Void)
    func getUser(email: String, completion: @escaping (Result<User, СustomError>) -> Void)
    
    func changeTask(_ task: Task, in group: Group, completion: @escaping (СustomError?) -> Void)
    func changeTitle(in group: Group, with title: String, completion: @escaping (СustomError?) -> Void)
    
    func deleteTask(_ task: Task, in group: Group)
    func deleteGroup(_ group: Group, completion: @escaping (СustomError?) -> Void)
    func deleteUser(_ user: User, from group: Group)
}

final class GroupsManager: GroupsManagerDescription {
    
    static let shared: GroupsManagerDescription = GroupsManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Observe
    
    func observeGroups(completion: @escaping (Result<[Group], СustomError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(СustomError.noSignedUser))
            return
        }
        database.collection(Collection.groups.rawValue).addSnapshotListener { (querySnapshot, error) in
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
        database.collection(Collection.groups.rawValue).document(userId).addSnapshotListener { (querySnapshot, error) in
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
        database.collection(Collection.users.rawValue).document(saveUserId).addSnapshotListener { (snapshot, error) in
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
    
    // MARK: - Add
    
    func addGroup(title: String, users: [String], photo: UIImage?, completion: @escaping (Error?) -> Void) {
        let ref = database.collection(Collection.groups.rawValue).document()
        let docId = ref.documentID
        var imageName: String = "default"
        ImagesManager.loadPhotoToStorage(id: docId, photo: photo) { (myResult) in
            switch myResult {
            case .success(let url):
                imageName = url.absoluteString
            case .failure(_):
                imageName = "default"
            }
            ref.setData([GroupKey.id.rawValue : docId,
                         GroupKey.title.rawValue : title,
                         GroupKey.image.rawValue : imageName,
                         GroupKey.tasks.rawValue : [],
                         GroupKey.users.rawValue : users]) { err in
                completion(err)
            }
        }
    }
    
    func addFriend(friend: User) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        database.collection(Collection.users.rawValue).document(userId).updateData([UserKey.friends.rawValue : FieldValue.arrayUnion([friend.id])])
    }
    
    func addUsers(_ users: [User], to group: Group) {
        var usersId = [String]()
        for user in users {
            usersId.append(user.id)
        }
        database.collection(Collection.groups.rawValue).document(group.id).setData([GroupKey.users.rawValue: FieldValue.arrayUnion(usersId)], merge: true)
    }
    
    func addTask(_ task: Task, in group: Group) {
        var tasks = [GroupsConverter.task(from: task)]
        for task in group.tasks {
            tasks.append(GroupsConverter.task(from: task))
        }
        database.collection(Collection.groups.rawValue).document(group.id).setData([GroupKey.tasks.rawValue: tasks], merge: true)
    }
    
    // MARK: - Get
    
    func getGroups(completion: @escaping (Result<[Group], СustomError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(СustomError.noSignedUser))
            return
        }
        database.collection(Collection.groups.rawValue).getDocuments { (querySnapshot, error) in
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
    
    func getUser(userId: String, completion: @escaping (Result<User, СustomError>) -> Void) {
        let docRef = database.collection(Collection.users.rawValue).document(userId)
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
        database.collection(Collection.users.rawValue).getDocuments { (snapshot, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(СustomError.unexpected))
                return
            }
            for document in documents {
                guard let docEmail = document[UserKey.email.rawValue] as? String else {
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
    
    func getTasks(for userId: String, from group: Group) -> [Task] {
        var tasks = [Task]()
        for task in group.tasks {
            if userId == task.userId {
                tasks.append(task)
            }
        }
        return tasks
    }
    
    // MARK: - Change
    
    func changeTask(_ task: Task, in group: Group, completion: @escaping (СustomError?) -> Void) {
        var tasks = [GroupsConverter.task(from: task)]
        for el in group.tasks {
            if el.id != task.id {
                tasks.append(GroupsConverter.task(from: el))
            }
        }
        database.collection(Collection.groups.rawValue).document(group.id).updateData([GroupKey.tasks.rawValue : tasks]) { err in
            if err != nil {
                completion(.unexpected)
            }
        }
    }
    
    func changeTitle(in group: Group, with title: String, completion: @escaping (СustomError?) -> Void) {
        database.collection(Collection.groups.rawValue).document(group.id).updateData([GroupKey.title.rawValue : title]) { err in
            if err != nil {
                completion(.unexpected)
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteTask(_ task: Task, in group: Group) {
        database.collection(Collection.groups.rawValue).document(group.id).updateData([
            GroupKey.tasks.rawValue : FieldValue.arrayRemove([GroupsConverter.task(from: task)]),
        ])
    }
    
    func deleteGroup(_ group: Group, completion: @escaping (СustomError?) -> Void) {
        database.collection(Collection.groups.rawValue).document(group.id).delete { (err) in
            guard err != nil else {
                completion(nil)
                return
            }
            completion(.failedToDelete)
        }
    }
    
    func deleteUser(_ user: User, from group: Group) {
        database.collection(Collection.groups.rawValue).document(group.id).updateData([
            GroupKey.users.rawValue : FieldValue.arrayRemove([user.id]),
        ])
    }
}
