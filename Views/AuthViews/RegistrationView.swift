import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @EnvironmentObject private var router: NavigationRouter

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.registration.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.registration.password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.oneTimeCode)
                
                SecureField("Confirm password", text: $viewModel.registration.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.oneTimeCode)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button("Create account") {
                    viewModel.register { success in
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                router.pop()
                            }
                        }
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)

                if viewModel.isLoading {
                    ProgressView()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")

            if viewModel.showSuccessToast {
                ToastView(message: "Account created successfully!")
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
    }
}
