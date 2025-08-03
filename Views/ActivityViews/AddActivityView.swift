import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddActivityViewModel()
    var onAdd: (ActivityModel?) -> Void

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
            }
            .navigationTitle("New Activity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newActivity = viewModel.createActivity()
                        onAdd(newActivity)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
