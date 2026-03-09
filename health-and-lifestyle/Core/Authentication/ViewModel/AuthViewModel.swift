import Foundation
import FirebaseAuth
import FirebaseFirestore
internal import Combine

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showWrongPasswordError = false
    @Published var isLoading = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        if let uid = userSession?.uid {
            fetchUser(uid: uid)
        }
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
            if let uid = authResult?.user.uid {
                self.fetchUser(uid: uid)
            }
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
            
            guard let firebaseUser = result?.user else { return }
            
            let user = User(id: firebaseUser.uid, fullname: fullname, email: email)
            let encodedUser = try? Firestore.Encoder().encode(user)
            
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser ?? [:]) { _ in
                DispatchQueue.main.async {
                    self?.userSession = firebaseUser
                    self?.currentUser = user
                }
                completion?(nil)
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    func fetchUser(uid: String) {
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self?.currentUser = try? Firestore.Decoder().decode(User.self, from: data)
                }
                return
            }
            
            DispatchQueue.main.async {
                guard let firebaseUser = Auth.auth().currentUser else { return }
                let fallbackUser = User(
                    id: firebaseUser.uid,
                    fullname: firebaseUser.displayName ?? "Unknown",
                    email: firebaseUser.email ?? ""
                )
                let encoded = try? Firestore.Encoder().encode(fallbackUser)
                Firestore.firestore().collection("users").document(uid).setData(encoded ?? [:])
                self?.currentUser = fallbackUser
            }
        }
    }
}
