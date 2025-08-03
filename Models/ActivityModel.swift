import Foundation
import SwiftUI

struct ActivityModel: Identifiable, Hashable, Codable {
    let id: UUID
    var form: ActivityFormModel

    enum ImportanceLevel: String, CaseIterable, Identifiable, Codable {
        case low, medium, high
        var id: String { self.rawValue }

        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }

        var priority: Int {
            switch self {
            case .high: return 3
            case .medium: return 2
            case .low: return 1
            }
        }
    }
}
