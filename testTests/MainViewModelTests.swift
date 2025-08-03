import XCTest
@testable import test

final class MainViewModelTests: XCTestCase {
    func testSortByDate() {
        let activity1 = ActivityModel(id: UUID(), form: ActivityFormModel(
            title: "One",
            description: "Desc",
            importance: .medium,
            date: Date(timeIntervalSince1970: 1000),
            isCompleted: false
        ))
        let activity2 = ActivityModel(id: UUID(), form: ActivityFormModel(
            title: "Two",
            description: "Desc",
            importance: .high,
            date: Date(timeIntervalSince1970: 2000),
            isCompleted: false
        ))

        let viewModel = MainViewModel()
        viewModel.activities = [activity2, activity1]

        viewModel.selectedSort = .byDate

        XCTAssertEqual(viewModel.activities.first?.form.title, "One")
        XCTAssertEqual(viewModel.activities.last?.form.title, "Two")
    }

    func testSortByImportance() {
        let activity1 = ActivityModel(id: UUID(), form: ActivityFormModel(
            title: "Low",
            description: "Desc",
            importance: .low,
            date: Date(),
            isCompleted: false
        ))
        let activity2 = ActivityModel(id: UUID(), form: ActivityFormModel(
            title: "High",
            description: "Desc",
            importance: .high,
            date: Date(),
            isCompleted: false
        ))

        let viewModel = MainViewModel()
        viewModel.activities = [activity1, activity2]

        viewModel.selectedSort = .byImportance

        XCTAssertEqual(viewModel.activities.first?.form.title, "High")
        XCTAssertEqual(viewModel.activities.last?.form.title, "Low")
    }
}
