import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AuthManagerDescription {
    func signUp(email: String, name: String, password1: String, password2: String) -> String?
    func signIn(email: String, password: String) -> String?
}

final class AuthManager: AuthManagerDescription {
    
    static let shared: AuthManagerDescription = AuthManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func signUp(email: String, name: String, password1: String, password2: String) -> String? {
        // Validate the fields
        let error = validateInput(email: email, name: name, password1: password1, password2: password2, isSignIn: false)
        
        if error != nil {
            // There's something wrong with the fields, show error message
            return error
        } else {
            // Create cleaned versions of the data
            let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            
            var res: String? = nil
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    print(err!.localizedDescription)
                    // There was an error creating the user
                    res = "Error creating user"
                } else {
                    // User was created successfully, now store the first name and last name
                    self.database.collection("users").document(result!.user.uid).setData(["email" : email, "name" : name, "image" : "user", "id" : result!.user.uid ]) { (error) in
                        if error != nil {
                            // Show error message
                            res = "Error saving user data"
                        }
                    }
                }
            }
            return res
        }
    }
    
    func signIn(email: String, password: String) -> String? {
        // Validate Text Fields
        let error = validateInput(email: email, password1: password, isSignIn: true)
        
        if error != nil {
            // There's something wrong with the fields, show error message
            return error
        } else {
            // Create cleaned versions of the text field
            let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            var res: String? = nil
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    res = error?.localizedDescription
                }
            }
            return res
        }
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateInput(email: String, name: String = "", password1: String, password2: String = "", isSignIn: Bool) -> String? {
        
        // Check that all fields are filled in
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password1.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Пожалуйста, заполните все поля."
        }
        if !isSignIn {
            if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password2.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Пожалуйста, заполните все поля."
            }
            // Check if the password is secure
            let cleanedPassword1 = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword2 = password2.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanedPassword1 != cleanedPassword2 {
                return "Вы ввели разные пароли."
            }
            if cleanedPassword1.count < 6 {
                // Password isn't secure enough
                return "Пожалуйста, убедитесь, что Ваш пароль содержит хотя бы 6 символа."
            }
        }
        return nil
    }
}
