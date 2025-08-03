import Foundation

struct ActivityFormModel: Codable, Hashable {
    var title: String = ""
    var description: String = ""
    var importance: ActivityModel.ImportanceLevel = .medium
    var date: Date = Date()
    var isCompleted: Bool = false
}
