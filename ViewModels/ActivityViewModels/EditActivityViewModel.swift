import Foundation
import SwiftUI

final class EditActivityViewModel: ObservableObject {
    @Published var form: ActivityFormModel
    private let originalActivity: ActivityModel

    init(activity: ActivityModel) {
        self.originalActivity = activity
        self.form = activity.form
    }

    var isSaveDisabled: Bool {
        form.title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func updatedActivity() -> ActivityModel {
        ActivityModel(id: originalActivity.id, form: form)
    }
}
