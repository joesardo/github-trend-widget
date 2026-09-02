import WidgetKit
import SwiftUI

struct TrendEntry: TimelineEntry {
    let date: Date
    let query: String
    let repositories: [GitHubRepository]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TrendEntry {
        TrendEntry(date: .now, query: "SwiftUI", repositories: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TrendEntry) -> Void) {
        completion(load())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TrendEntry>) -> Void) {
        let entry = load()
        let next = Calendar.current.date(byAdding: .hour, value: 2, to: .now)!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func load() -> TrendEntry {
        TrendEntry(date: .now,
                   query: SharedStore.defaults.string(forKey: SharedStore.queryKey) ?? "SwiftUI",
                   repositories: SharedStore.loadRepositories())
    }
}

struct GitHubTrendWidgetView: View {
    let entry: TrendEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack { Text("🔥"); Text(entry.query).font(.headline).lineLimit(1); Spacer() }
            if entry.repositories.isEmpty {
                Text("Open GitHub Trend and refresh to load repositories.")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(entry.repositories.prefix(4)) { repo in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(repo.fullName).font(.caption.bold()).lineLimit(1)
                            HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                Text(repo.stars.formatted())
                                if let language = repo.language { Text("• \(language)") }
                            }.font(.caption2).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(repo.trendScore)").font(.caption.bold())
                    }
                }
            }
            Spacer(minLength: 0)
            Text("GitHub Trend").font(.caption2).foregroundStyle(.tertiary)
        }
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

@main
struct GitHubTrendWidgetWidget: Widget {
    let kind = "GitHubTrendWidgetWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GitHubTrendWidgetView(entry: entry)
        }
        .configurationDisplayName("GitHub Trend")
        .description("See repositories gaining attention around your search.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
