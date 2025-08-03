import SwiftUI
import Firebase

@main
struct TrackingApp: App {
    @StateObject private var router = NavigationRouter()
    
    init() {
        FirebaseApp.configure()
        NotificationService.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var router: NavigationRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if AuthService.shared.isSessionActive {
                    MainView()
                } else {
                    LoginView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .main:
                    MainView()
                case .login:
                    LoginView()
                case .registration:
                    RegistrationView()
                case .profile:
                    ProfileView()
                }
            }
        }
    }
}
