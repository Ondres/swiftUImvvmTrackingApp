import SwiftUI

struct ActivityDetailSheet: View {
    @State private var form: ActivityFormModel
    let onUpdate: (ActivityFormModel) -> Void

    init(activity: ActivityModel, onUpdate: @escaping (ActivityFormModel) -> Void) {
        _form = State(initialValue: activity.form)
        self.onUpdate = onUpdate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(form.title)
                .font(.largeTitle)
                .bold()

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Description:")
                    .font(.headline)
                Text(form.description)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Importance:")
                    .font(.headline)
                Text(form.importance.rawValue.capitalized)
                    .foregroundColor(form.importance.color)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Date:")
                    .font(.headline)
                Text(form.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.body)
            }

            Toggle("Mark as completed", isOn: $form.isCompleted)
                .onChange(of: form.isCompleted) { newValue in
                    onUpdate(form)
                }

            Spacer()
        }
        .padding()
        .navigationTitle("Activity details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
