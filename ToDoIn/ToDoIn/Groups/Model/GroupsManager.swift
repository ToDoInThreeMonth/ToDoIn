import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol GroupsManagerDescription {
    func observeGroup(by userId: String, completion: @escaping (Result<Group, СustomError>) -> Void)
    func observeCurrentUser(completion: @escaping (Result<User, СustomError>) -> Void)
    
    func addGroup(title: String, users: [String], photo: UIImage?, completion: @escaping (Error?) -> Void)
    func addUsers(_ users: [User], to group: Group)
    func addTask(_ task: Task, in group: Group)

    func getGroups(completion: @escaping (Result<[Group], СustomError>) -> Void)
    func getTasks(for userId: String, from group: Group) -> [Task]
    func getUser(userId: String, completion: @escaping (Result<User, СustomError>) -> Void)
    
    func changeTask(_ task: Task, in group: Group, completion: @escaping (СustomError?) -> Void)
    func changeTitle(in group: Group, with title: String, completion: @escaping (СustomError?) -> Void)
    func changeGroupAvatar(with image: UIImage?, in groupId: String, completion: @escaping (СustomError?) -> Void)
    
    func deleteTask(_ task: Task, in group: Group)
    func deleteGroup(_ group: Group, completion: @escaping (СustomError?) -> Void)
    func deleteUser(_ user: User, from group: Group)
}

final class GroupsManager: GroupsManagerDescription {
    
    static let shared: GroupsManagerDescription = GroupsManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Observe
    
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
    
    func observeCurrentUser(completion: @escaping (Result<User, СustomError>) -> Void) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        database.collection(Collection.users.rawValue).document(userId).addSnapshotListener { (snapshot, error) in
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
        
        ref.setData([GroupKey.id.rawValue : docId,
                     GroupKey.title.rawValue : title,
                     GroupKey.image.rawValue : imageName,
                     GroupKey.tasks.rawValue : [],
                     GroupKey.users.rawValue : users]) { (error) in
                if error != nil {
                    completion(error)
                } else {
                    completion(nil)
                    ImagesManager.loadPhotoToStorage(id: docId, photo: photo) { (res) in
                        switch res {
                        case .success(let url):
                            imageName = url.absoluteString
                            ref.updateData([UserKey.image.rawValue : imageName]) { (_) in
                                completion(nil)
                            }
                        case .failure(_):
                            imageName = "default"
                        }
                    }
                }
            }
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
                completion(СustomError.error)
            } else {
                completion(nil)
            }
        }
    }
    
    func changeGroupAvatar(with image: UIImage?, in groupId: String, completion: @escaping (СustomError?) -> Void) {
        ImagesManager.loadPhotoToStorage(id: groupId, photo: image) { [weak self] (res) in
            switch res {
            case .success(let url):
                self?.database.collection(Collection.groups.rawValue).document(groupId).updateData([GroupKey.image.rawValue : url.absoluteString]) { (err) in
                    if err != nil {
                        completion(СustomError.unexpected)
                    } else {
                        completion(nil)
                    }
                }
            case .failure(_):
                completion(СustomError.failedToChangeAvatar)
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
