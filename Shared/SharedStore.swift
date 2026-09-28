import Foundation
import WidgetKit

enum SharedStore {
    static let widgetKind = "TrendsWidget"

    // 1. Generate a direct file path on the system instead of using an App Group container
    static var cacheFileURL: URL {
        let manager = FileManager.default
        let libraryFolder = manager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let cacheFolder = libraryFolder.appendingPathComponent("Caches", isDirectory: true)
        return cacheFolder.appendingPathComponent("github_trends_cache.json")
    }

    static func loadRepositories() -> [GitHubRepository] {
        guard let data = try? Data(contentsOf: cacheFileURL) else { return [] }
        return (try? JSONDecoder().decode([GitHubRepository].self, from: data)) ?? []
    }

    static func loadQuery() -> String {
        // Fallback or read from an alternate local string file if needed
        return "SwiftUI" 
    }

    static func saveQuery(_ query: String, reloadWidgets: Bool = false) {
        // You can save this to a secondary local file path if needed
        if reloadWidgets {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    static func saveRepositories(_ repositories: [GitHubRepository], reloadWidgets: Bool = true) {
        guard let data = try? JSONEncoder().encode(repositories) else { return }
        
        // 2. Write straight to disk via file URL
        try? data.write(to: cacheFileURL, options: .atomic)
        
        if reloadWidgets {
            WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
