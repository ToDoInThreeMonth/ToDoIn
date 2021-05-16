import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AuthManagerDescription {
    func signUp(email: String, name: String, password1: String, password2: String, photo: UIImage?, completion: @escaping (Result<String, СustomError>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<String, СustomError>) -> Void)
    func signOut()
    
    func isSignedIn() -> Bool
    
    func getCurrentUser() -> User
    func getCurrentUserId() -> String?
}

final class AuthManager: AuthManagerDescription {
    
    static let shared: AuthManagerDescription = AuthManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func signUp(email: String, name: String, password1: String, password2: String, photo: UIImage?, completion: @escaping (Result<String, СustomError>) -> Void) {
        let error = validateInput(email: email, name: name, password1: password1, password2: password2, isSignIn: false)
        
        if let error = error {
            completion(.failure(error))
            return
        }
        
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password1.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            guard let result = result else {
                completion(.failure(СustomError.failedToCreateUser))
                return
            }
            var imageName: String = "default"
            ImagesManager.loadPhotoToStorage(id: result.user.uid, photo: photo) { (myResult) in
                switch myResult {
                case .success(let url):
                    imageName = url.absoluteString
                case .failure(_):
                    imageName = "default"
                }
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
                        }
                    }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, СustomError>) -> Void) {
        let error = validateInput(email: email, password1: password, isSignIn: true)
        
        if let error = error {
            completion(.failure(error))
            return
        }
        
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: Notification.Name("AuthChanged"), object: nil, userInfo: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
    
    /// Проверка введеных пользователем данных
    func validateInput(email: String, name: String = "", password1: String, password2: String = "", isSignIn: Bool) -> СustomError? {
        
        // Все ли поля заполнены
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password1.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return СustomError.emptyInput
        }
        if !isSignIn {
            if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password2.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return СustomError.emptyInput
            }
            // Проверка пароля
            let cleanedPassword1 = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword2 = password2.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanedPassword1 != cleanedPassword2 {
                return СustomError.differentPasswords
            }
            if cleanedPassword1.count < 6 {
                // Пароль не безопасный
                return СustomError.incorrectPassword
            }
        }
        return nil
    }
    
}
