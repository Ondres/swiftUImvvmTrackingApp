import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showDeleteAlert = false
    @State private var showSuccessToast = false
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if let email = viewModel.userEmail {
                    Text("Email: \(email)")
                        .font(.headline)
                } else {
                    Text("Failed to fetch user data.")
                        .foregroundColor(.red)
                }

                Button("Sign out") {
                    viewModel.signOut { success in
                        if success {
                            router.path = [.login]
                            router.popToRoot()
                        }
                    }
                }
                .foregroundColor(.blue)

                Button("Delete account") {
                    showDeleteAlert = true
                }
                .foregroundColor(.red)
            }
            .padding()
            .navigationTitle("Profile")
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete account?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAccount { success in
                            if success {
                                showSuccessToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    router.path = [.login]
                                    router.popToRoot()
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }

            if showSuccessToast {
                ToastView(message: "Account deleted successfully!")
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                showSuccessToast = false
                            }
                        }
                    }
            }
        }
    }
}
