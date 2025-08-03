import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.auth.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.auth.password)
                    .textFieldStyle(.roundedBorder)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Button("Sign In") {
                    viewModel.login { success in
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                router.path = [.main]
                                router.popToRoot()
                            }
                        }
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
                
                Button("Don't have an account? Register") {
                    router.push(.registration)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle("Sign In")
            
            if viewModel.showSuccessToast {
                ToastView(message: "Login successful!")
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                viewModel.showSuccessToast = false
                            }
                        }
                    }
            }
        }

        .onAppear {
            if AuthService.shared.isSessionActive {
                router.path = [.main]
                router.popToRoot()
            }
        }
    }
}
