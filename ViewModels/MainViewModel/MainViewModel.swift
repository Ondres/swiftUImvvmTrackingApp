import Foundation
import SwiftUI
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var activities: [ActivityModel] = []
    @Published var showingAddActivity = false
    @Published var selectedSort: SortOption = .byDate {
        didSet {
            applySort()
        }
    }

    init() {
        loadActivities()
    }

    func loadActivities() {
        guard let userId = Auth.auth().currentUser?.uid else {
            Logger.error("User is not authenticated")
            activities = []
            return
        }

        FirebaseActivityStorage.shared.fetchActivities(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loadedActivities):
                    withAnimation {
                        self?.activities = loadedActivities
                        self?.applySort()
                    }
                    NotificationService.shared.scheduleNotifications(for: loadedActivities)
                case .failure(let error):
                    Logger.error("Failed to load activities: \(error.localizedDescription)")
                }
            }
        }
    }

    func addActivity(_ activity: ActivityModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        FirebaseActivityStorage.shared.save(activity, for: userId) { [weak self] result in
            switch result {
            case .success:
                NotificationService.shared.scheduleNotification(for: activity)
                self?.loadActivities()
            case .failure(let error):
                Logger.error("Failed to add activity: \(error.localizedDescription)")
            }
        }
    }

    func deleteActivity(_ activity: ActivityModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        FirebaseActivityStorage.shared.delete(activity, for: userId) { [weak self] result in
            switch result {
            case .success:
                NotificationService.shared.removeNotification(for: activity)
                self?.loadActivities()
            case .failure(let error):
                Logger.error("Failed to delete activity: \(error.localizedDescription)")
            }
        }
    }

    func updateActivity(_ activity: ActivityModel) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        FirebaseActivityStorage.shared.update(activity, for: userId) { [weak self] result in
            switch result {
            case .success:
                NotificationService.shared.removeNotification(for: activity)
                NotificationService.shared.scheduleNotification(for: activity)
                self?.loadActivities()
            case .failure(let error):
                Logger.error("Failed to update activity: \(error.localizedDescription)")
            }
        }
    }

    private func applySort() {
        switch selectedSort {
        case .byDate:
            activities.sort { $0.form.date < $1.form.date }
        case .byImportance:
            activities.sort { $0.form.importance.priority > $1.form.importance.priority }
        case .byTitle:
            activities.sort { $0.form.title.lowercased() < $1.form.title.lowercased() }
        }
    }
}
