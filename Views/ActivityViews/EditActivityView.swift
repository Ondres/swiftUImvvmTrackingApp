import SwiftUI

struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: EditActivityViewModel
    var onComplete: (ActivityModel?) -> Void

    init(activity: ActivityModel, onComplete: @escaping (ActivityModel?) -> Void) {
        _viewModel = StateObject(wrappedValue: EditActivityViewModel(activity: activity))
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $viewModel.form.title)
                }
                Section(header: Text("Description")) {
                    TextField("Enter description", text: $viewModel.form.description)
                }
                Section(header: Text("Importance")) {
                    Picker("Importance Level", selection: $viewModel.form.importance) {
                        ForEach(ActivityModel.ImportanceLevel.allCases) { level in
                            Text(level.rawValue.capitalized)
                                .foregroundColor(level.color)
                                .tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $viewModel.form.date, displayedComponents: [.date, .hourAndMinute])
                }
                Section(header: Text("Completed")) {
                    Toggle("Completed", isOn: $viewModel.form.isCompleted)
                }
            }
            .navigationTitle("Edit Activity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = viewModel.updatedActivity()
                        onComplete(updated)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onComplete(nil)
                        dismiss()
                    }
                }
            }
        }
    }
}
