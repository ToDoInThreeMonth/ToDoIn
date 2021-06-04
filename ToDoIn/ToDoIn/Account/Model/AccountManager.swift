import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AccountManagerDescription {
    func observeCurrentUser(completion: @escaping (Result<User, СustomError>) -> Void)
    
    func getUser(userId: String?, completion: @escaping (Result<User, СustomError>) -> Void)
    func getUser(email: String, completion: @escaping (Result<User, СustomError>) -> Void)
    
    func addFriend(friend: User)

    func deleteFriend(_ friend: User)
    
    func changeUserAvatar(with image: UIImage?, completion: @escaping (СustomError?) -> Void)
}

final class AccountManager: AccountManagerDescription {
    
    static let shared: AccountManagerDescription = AccountManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
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
    
    func getUser(userId: String?, completion: @escaping (Result<User, СustomError>) -> Void) {
        let saveUserId: String
        if let userID = userId {
            saveUserId = userID
        } else {
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            saveUserId = currentUserId
        }
        let docRef = database.collection(Collection.users.rawValue).document(saveUserId)
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
    
    func addFriend(friend: User) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        database.collection(Collection.users.rawValue).document(userId).updateData([UserKey.friends.rawValue : FieldValue.arrayUnion([friend.id])])
    }
    
    func deleteFriend(_ friend: User) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        database.collection(Collection.users.rawValue).document(currentUserId).updateData([
            UserKey.friends.rawValue : FieldValue.arrayRemove([friend.id]),
        ])
    }
    
    func changeUserAvatar(with image: UIImage?, completion: @escaping (СustomError?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        ImagesManager.loadPhotoToStorage(id: userId, photo: image) { [weak self] (res) in
            switch res {
            case .success(let url):
                self?.database.collection(Collection.users.rawValue).document(userId).updateData([UserKey.image.rawValue : url.absoluteString])
            case .failure(_):
                completion(СustomError.failedToChangeAvatar)
            }
        }
    }
    
}
