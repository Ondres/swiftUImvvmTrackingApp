import Foundation

final class LoginViewModel: ObservableObject {
    @Published var auth = AuthModel()
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showSuccessToast = false

    var isFormValid: Bool {
        !auth.email.isEmpty && !auth.password.isEmpty
    }

    func login(completion: @escaping (Bool) -> Void) {
        isLoading = true
        AuthService.shared.login(email: auth.email, password: auth.password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    Logger.info("User logged in: \(self.auth.email)")
                    self.showSuccessToast = true
                    completion(true)
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    Logger.error("Login error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
