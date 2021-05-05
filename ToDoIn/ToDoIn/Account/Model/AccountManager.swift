import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AccountManagerDescription {
    func observeUser(completion: @escaping (Result<User, Error>) -> Void)

    func getUser(by email: String, completion: @escaping (Result<User, Error>) -> Void)
    func addFriend(friend: User)
}

final class AccountManager: AccountManagerDescription {
    
    static let shared: AccountManagerDescription = AccountManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func observeUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        database.collection("users").document(currentUserId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data() else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            let user = GroupsConverter.user(from: data)
            completion(.success(user))
        }
    }
    
    func getUser(by email: String, completion: @escaping (Result<User, Error>) -> Void) {
        database.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }
            for document in documents {
                guard let docEmail = document["email"] as? String else {
                    continue
                }
                if docEmail == email {
                   let user = GroupsConverter.user(from: document.data())
                    completion(.success(user))
                }
            }
        }
    }
    
    func addFriend(friend: User) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        database.collection("users").document(userId).updateData(["friends" : FieldValue.arrayUnion([friend.id])]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
