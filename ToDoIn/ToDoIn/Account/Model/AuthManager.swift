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
    
    func getCurrentUser() -> User {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return User()
        }
        var user = User()
        database.collection("users").document(currentUserId).addSnapshotListener { (snapshot, error) in
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
    
    func signUp(email: String, name: String, password1: String, password2: String, photo: UIImage?, completion: @escaping (Result<String, СustomError>) -> Void) {
        let error = validateInput(email: email, name: name, password1: password1, password2: password2, isSignIn: false)
        
        if error != nil {
            completion(.failure(error!))
        } else {
            // Create cleaned versions of the data
            let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    completion(.failure(СustomError.failedToCreateUser))
                } else {
                    var imageName: String = "default"
                    ImagesManager.uploadPhoto(id: result!.user.uid, photo: photo) { (myResult) in
                        switch myResult {
                        case .success(let url):
                            imageName = url.absoluteString
                        case .failure(_):
                            imageName = "default"
                        }
                        self.database
                            .collection("users")
                            .document(result!.user.uid)
                            .setData(["email" : email,
                                      "name" : name,
                                      "image" : imageName,
                                      "id" : result!.user.uid,
                                      "friends" : []]) { (error) in
                                if error != nil {
                                    completion(.failure(СustomError.failedToSaveUserInFireStore))
                                } else {
                                    UserDefaults.standard.set(true, forKey: "status")
                                    completion(.success(Auth.auth().currentUser?.uid ?? "nil"))
                                }
                            }
                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, СustomError>) -> Void) {
        let error = validateInput(email: email, password1: password, isSignIn: true)
        
        if error != nil {
            completion(.failure(error!))
        } else {
            // Create cleaned versions of the text field
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    completion(.failure(СustomError.noUser))
                } else {
                    UserDefaults.standard.set(true, forKey: "status")
                    completion(.success(Auth.auth().currentUser?.uid ?? "nil"))
                }
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "status")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func isSignedIn() -> Bool {
        guard (Auth.auth().currentUser?.uid) != nil else {
            return false
        }
        return true
    }
    
    func getCurrentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    /// Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateInput(email: String, name: String = "", password1: String, password2: String = "", isSignIn: Bool) -> СustomError? {
        
        // Check that all fields are filled in
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password1.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return СustomError.emptyInput
        }
        if !isSignIn {
            if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password2.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return СustomError.emptyInput
            }
            // Check if the password is secure
            let cleanedPassword1 = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword2 = password2.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanedPassword1 != cleanedPassword2 {
                return СustomError.differentPasswords
            }
            if cleanedPassword1.count < 6 {
                // Password isn't secure enough
                return СustomError.incorrectPassword
            }
        }
        return nil
    }
    
}
