import Foundation
import FirebaseAuth
internal import Combine

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var showWrongPasswordError = false
    @Published var isLoading = false
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email: String, password: String) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error as NSError? {
                if error.code == AuthErrorCode.wrongPassword.rawValue {
                    self.showWrongPasswordError = true
                } else {
                    self.showWrongPasswordError = false
                    print("Failed to sign in: \(error.localizedDescription)")
                }
                return
            }
            
            self.showWrongPasswordError = false
            
            self.userSession = authResult?.user
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, completion: ((String?) -> Void)? = nil) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error = error as NSError? {
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        completion?("An account with this email already exists.")
                    case .invalidEmail:
                        completion?("The email address is invalid.")
                    case .weakPassword:
                        completion?("The password is too weak.")
                    default:
                        completion?(error.localizedDescription)
                    }
                } else {
                    completion?(error.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.userSession = result?.user
            }
            completion?(nil)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
