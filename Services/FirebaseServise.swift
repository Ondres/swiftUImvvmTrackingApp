import Foundation
import FirebaseFirestore

final class FirebaseActivityStorage {
    static let shared = FirebaseActivityStorage()
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    private let activitiesCollection = "activities"
    
    private init() {}
    
    func fetchActivities(for userId: String, completion: @escaping (Result<[ActivityModel], Error>) -> Void) {
        db.collection(usersCollection)
            .document(userId)
            .collection(activitiesCollection)
            .getDocuments { snapshot, error in
                if let error = error {
                    Logger.error("Failed to fetch activities: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    do {
                        let activities = try snapshot?.documents.compactMap {
                            try $0.data(as: ActivityModel.self)
                        } ?? []
                        Logger.info("Fetched \(activities.count) activities for user \(userId)")
                        completion(.success(activities))
                    } catch {
                        Logger.error("Error decoding activities: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func save(_ activity: ActivityModel, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection(usersCollection)
                .document(userId)
                .collection(activitiesCollection)
                .document(activity.id.uuidString)
                .setData(from: activity) { error in
                    if let error = error {
                        Logger.error("Failed to save activity: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        Logger.info("Activity saved for user \(userId), id: \(activity.id.uuidString)")
                        completion(.success(()))
                    }
                }
        } catch {
            Logger.error("Encoding activity failed: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func update(_ activity: ActivityModel, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        save(activity, for: userId, completion: completion)
    }
    
    func delete(_ activity: ActivityModel, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(usersCollection)
            .document(userId)
            .collection(activitiesCollection)
            .document(activity.id.uuidString)
            .delete { error in
                if let error = error {
                    Logger.error("Failed to delete activity: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    Logger.info("Activity deleted for user \(userId), id: \(activity.id.uuidString)")
                    completion(.success(()))
                }
            }
    }
}
