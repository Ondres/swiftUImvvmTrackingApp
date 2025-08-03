enum SortOption: CaseIterable {
    case byDate
    case byImportance
    case byTitle

    var displayName: String {
        switch self {
        case .byDate: return "By date"
        case .byImportance: return "By importance"
        case .byTitle: return "By title"
        }
    }
}
