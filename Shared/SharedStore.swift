import Foundation
import WidgetKit

enum SharedStore {
    static let suiteName = "group.com.githubtrendwidget.mvp"
    static let repositoriesKey = "repositories"
    static let queryKey = "searchQuery"
    static let widgetKind = "TrendsWidget"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName)!
    }

    static func loadRepositories() -> [GitHubRepository] {
        guard let data = defaults.data(forKey: repositoriesKey) else { return [] }
        return (try? JSONDecoder().decode([GitHubRepository].self, from: data)) ?? []
    }

    static func loadQuery() -> String {
        let storedQuery = defaults.string(forKey: queryKey)
        let trimmedQuery = storedQuery?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmedQuery.isEmpty ? "SwiftUI" : trimmedQuery
    }

    static func saveQuery(_ query: String, reloadWidgets: Bool = false) {
        defaults.set(query, forKey: queryKey)
        if reloadWidgets {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    static func saveRepositories(_ repositories: [GitHubRepository], reloadWidgets: Bool = true) {
        guard let data = try? JSONEncoder().encode(repositories) else { return }
        defaults.set(data, forKey: repositoriesKey)
        if reloadWidgets {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
