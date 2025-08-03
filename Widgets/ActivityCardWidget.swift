import SwiftUI

struct ActivityCardWidget: View {
    let activity: ActivityModel
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(activity.form.title)

                Spacer()
                Menu {
                    Button("Edit", systemImage: "pencil", action: onEdit)
                    Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
            }

            Text(activity.form.description)
                .foregroundColor(Color("PrimaryTextColor"))
                .font(.custom("Luckyfield", size: 18))
                .lineLimit(2)
                .truncationMode(.tail)
                .padding(.bottom, 4)

            HStack(spacing: 6) {
                Circle()
                    .fill(activity.form.importance.color)
                    .frame(width: 10, height: 10)

                Text(activity.form.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if activity.form.isCompleted {
                Text("✅ Completed")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .cornerRadius(10)
        .shadow(radius: 2)
        .background(Color(.black))
    }
}
