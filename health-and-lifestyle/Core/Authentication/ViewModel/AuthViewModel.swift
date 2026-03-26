import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn
internal import Combine

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showWrongPasswordError = false
    @Published var isLoading = false

    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        self.userSession = Auth.auth().currentUser
        if let uid = userSession?.uid {
            fetchUser(uid: uid)
        }
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                guard let self else { return }
                self.userSession = user
                if let uid = user?.uid {
                    self.fetchUser(uid: uid)
                } else {
                    self.currentUser = nil
                }
            }
        }
    }

    deinit {
        if let authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
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
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        isLoading = true

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async { self.isLoading = false }
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let googleUser = result?.user,
                  let idToken = googleUser.idToken?.tokenString else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: googleUser.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }

                DispatchQueue.main.async { self.isLoading = false }

                if let error = error {
                    print("Firebase sign-in with Google failed: \(error.localizedDescription)")
                    return
                }

                guard let firebaseUser = authResult?.user else { return }

                let fullname = googleUser.profile?.name ?? "Unknown"
                let email = googleUser.profile?.email ?? ""

                Firestore.firestore().collection("users").document(firebaseUser.uid).getDocument { [weak self] snapshot, _ in
                    if snapshot?.exists == true {
                        DispatchQueue.main.async {
                            self?.userSession = firebaseUser
                            self?.fetchUser(uid: firebaseUser.uid)
                        }
                    } else {
                        let user = User(id: firebaseUser.uid, fullname: fullname, email: email)
                        let encoded = try? Firestore.Encoder().encode(user)
                        Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encoded ?? [:]) { _ in
                            DispatchQueue.main.async {
                                self?.userSession = firebaseUser
                                self?.currentUser = user
                            }
                        }
                    }
                }
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
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
