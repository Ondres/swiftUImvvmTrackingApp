import Foundation
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    var userEmail: String? {
        Auth.auth().currentUser?.email
    }

    func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try AuthService.shared.logout()
            Logger.info("User signed out")
            completion(true)
        } catch {
            Logger.error("Sign out error: \(error.localizedDescription)")
            completion(false)
        }
    }

    func deleteAccount(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        user.delete { error in
            if let error = error {
                Logger.error("Delete account error: \(error.localizedDescription)")
                completion(false)
            } else {
                Logger.info("Account deleted successfully")
                completion(true)
            }
        }
    }
}
