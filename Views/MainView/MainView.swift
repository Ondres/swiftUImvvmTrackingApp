import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var router: NavigationRouter

    @State private var editingActivity: ActivityModel? = nil
    @State private var showSortDialog = false
    @State private var detailSheetActivity: ActivityModel? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Activities")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryTextColor"))

                Spacer()

                Button(action: {
                    showSortDialog = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .imageScale(.medium)
                }
                .padding(.trailing, 4)

                Button(action: {
                    viewModel.showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .imageScale(.medium)
                }
                .padding(.trailing, 4)

                Button(action: {
                    router.push(.profile)
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .imageScale(.medium)
                }
            }
            .padding()
            .background(Color("BackgroundColor"))

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.activities) { activity in
                        Button(action: {
                            detailSheetActivity = activity
                        }) {
                            ActivityCardWidget(
                                activity: activity,
                                onEdit: { editingActivity = activity },
                                onDelete: { viewModel.deleteActivity(activity) }
                            )
                            .padding(.horizontal)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: viewModel.activities)
                .padding(.top)
            }
        }
        .background(Color("BackgroundColor"))
        .sheet(isPresented: $viewModel.showingAddActivity) {
            AddActivityView { newActivity in
                if let activity = newActivity {
                    viewModel.addActivity(activity)
                }
                viewModel.showingAddActivity = false
            }
        }
        .sheet(item: $editingActivity) { activity in
            EditActivityView(activity: activity) { updatedActivity in
                if let updated = updatedActivity {
                    viewModel.updateActivity(updated)
                }
                editingActivity = nil
            }
        }
        .sheet(item: $detailSheetActivity) { activity in
            ActivityDetailSheet(
                activity: activity,
                onUpdate: { updatedForm in
                    var updated = activity
                    updated.form = updatedForm
                    viewModel.updateActivity(updated)
                }
            )
        }
        .confirmationDialog(
            "Sort by",
            isPresented: $showSortDialog,
            titleVisibility: .visible
        ) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(option.displayName) {
                    viewModel.selectedSort = option
                }
            }
        }
    }
}
