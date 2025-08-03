import Foundation
import SwiftUI

final class AddActivityViewModel: ObservableObject {
    @Published var form = ActivityFormModel()

    var isSaveDisabled: Bool {
        form.title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func createActivity() -> ActivityModel {
        ActivityModel(id: UUID(), form: form)
    }
}
