import Foundation
import WidgetKit

enum SharedStore {
    static let suiteName = "group.com.githubtrendwidget.mvp"
    static let repositoriesKey = "repositories"
    static let queryKey = "searchQuery"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName)!
    }

    static func loadRepositories() -> [GitHubRepository] {
        guard let data = defaults.data(forKey: repositoriesKey) else { return [] }
        return (try? JSONDecoder().decode([GitHubRepository].self, from: data)) ?? []
    }

    static func saveRepositories(_ repositories: [GitHubRepository], reloadWidgets: Bool = true) {
        guard let data = try? JSONEncoder().encode(repositories) else { return }
        defaults.set(data, forKey: repositoriesKey)
        if reloadWidgets {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
