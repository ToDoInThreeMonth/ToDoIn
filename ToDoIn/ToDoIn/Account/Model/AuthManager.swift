import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AuthManagerDescription {
    func signUp(email: String, name: String, password: String, photo: UIImage?, completion: @escaping (Result<String, СustomError>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<String, СustomError>) -> Void)
    func signOut() -> СustomError?
    
    func isSignedIn() -> Bool
    
    func getCurrentUser() -> User
    func getCurrentUserId() -> String?
}

final class AuthManager: AuthManagerDescription {
    
    static let shared: AuthManagerDescription = AuthManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func signUp(email: String, name: String, password: String, photo: UIImage?, completion: @escaping (Result<String, СustomError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            guard let result = result else {
                completion(.failure(СustomError.failedToCreateUser))
                return
            }
            var imageName: String = "default"
            
            self.database
                .collection(Collection.users.rawValue)
                .document(result.user.uid)
                .setData([UserKey.email.rawValue : email,
                          UserKey.name.rawValue : name,
                          UserKey.image.rawValue : imageName,
                          UserKey.id.rawValue : result.user.uid,
                          UserKey.friends.rawValue : []]) { (error) in
                    if error != nil {
                        completion(.failure(СustomError.failedToSaveUserInFireStore))
                    } else {
                        UserDefaults.standard.set(true, forKey: "status")
                        completion(.success(Auth.auth().currentUser?.uid ?? ""))
                        
                        ImagesManager.loadPhotoToStorage(id: result.user.uid, photo: photo) { [weak self] (res) in
                            switch res {
                            case .success(let url):
                                imageName = url.absoluteString
                                self?.database
                                    .collection(Collection.users.rawValue)
                                    .document(result.user.uid)
                                    .updateData([UserKey.image.rawValue : imageName])
                            case .failure(_):
                                imageName = "default"
                            }
                        }
                    }
                }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, СustomError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(.failure(СustomError.noUser))
            } else {
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: Notification.Name("AuthChanged"), object: nil, userInfo: nil)
                completion(.success(Auth.auth().currentUser?.uid ?? ""))
            }
        }
    }
    
    func signOut() -> СustomError? {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: Notification.Name("AuthChanged"), object: nil, userInfo: nil)
            return nil
        } catch _ as NSError {
            return .failedToSignOut
        }
    }
    
    func isSignedIn() -> Bool {
        if (Auth.auth().currentUser?.uid) == nil {
            return false
        }
        return true
    }
    
    func getCurrentUser() -> User {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return User()
        }
        var user = User()
        database.collection(Collection.users.rawValue).document(currentUserId).addSnapshotListener { (snapshot, error) in
            if error != nil {
                return
            }
            guard let data = snapshot?.data() else {
                return
            }
            user = GroupsConverter.user(from: data)
        }
        return user
    }
    
    func getCurrentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
}
