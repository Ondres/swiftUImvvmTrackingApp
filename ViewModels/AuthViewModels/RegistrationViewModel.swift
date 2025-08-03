import Foundation

final class RegistrationViewModel: ObservableObject {
    @Published var registration = AuthModel()
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showSuccessToast = false

    var isFormValid: Bool {
        !registration.email.isEmpty &&
        !registration.password.isEmpty &&
        registration.password == registration.confirmPassword
    }

    func register(completion: @escaping (Bool) -> Void) {
        guard registration.password == registration.confirmPassword else {
            errorMessage = "Passwords do not match"
            Logger.error("Registration failed: passwords do not match")
            completion(false)
            return
        }

        isLoading = true
        AuthService.shared.register(email: registration.email, password: registration.password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    Logger.info("User registered: \(self.registration.email)")
                    self.showSuccessToast = true
                    completion(true)
                case .failure(let error):
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                    Logger.error("Registration error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
