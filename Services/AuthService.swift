import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    var userLoggedIn = false
    
    private init() {}

    var isSessionActive: Bool {
        Auth.auth().currentUser != nil && userLoggedIn
    }

    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                Logger.error("Registration failed: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                Logger.info("User registered with email: \(email)")
                completion(.success(()))
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                Logger.error("Login failed: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                self.userLoggedIn = true
                Logger.info("User logged in: \(email)")
                completion(.success(()))
            }
        }
    }

    func logout() throws {
        userLoggedIn = false
        try Auth.auth().signOut()
        Logger.info("User logged out")
    }
}
