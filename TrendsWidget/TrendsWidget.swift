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
        completion(loadCached())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TrendEntry>) -> Void) {
        let entry = loadCached()
        // Change .never to .atEnd to allow sequential manual reloads to pass cleanly
        completion(Timeline(entries: [entry], policy: .atEnd)) 
    }

    private func loadCached() -> TrendEntry {
        TrendEntry(date: .now,
                   query: SharedStore.loadQuery(),
                   repositories: SharedStore.loadRepositories())
    }
}

struct GitHubTrendWidgetView: View {
    let entry: TrendEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack { Text("🔥"); Text(entry.query).font(.headline).lineLimit(1); Spacer() }
            if entry.repositories.isEmpty {
                Text("No repositories available right now.")
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
struct TrendsWidgetExtension: Widget {
    let kind = "TrendsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GitHubTrendWidgetView(entry: entry)
        }
        .configurationDisplayName("GitHub Trend")
        .description("See repositories gaining attention around your search.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
