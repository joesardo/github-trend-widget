import SwiftUI
import AppKit

struct ContentView: View {
    @AppStorage("searchQuery", store: UserDefaults(suiteName: SharedStore.suiteName))
    private var searchQuery = "SwiftUI"
    @State private var repositories = SharedStore.loadRepositories()
    @State private var loading = false
    @State private var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("GitHub Trend").font(.largeTitle.bold())
            Text("Personalized GitHub discovery for your desktop.").foregroundStyle(.secondary)
            HStack {
                TextField("Search GitHub", text: $searchQuery).textFieldStyle(.roundedBorder)
                Button(loading ? "Loading…" : "Refresh") { Task { await refresh() } }
                    .disabled(loading || searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            if let error { Text(error).foregroundStyle(.red) }
            List(repositories) { repo in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(repo.fullName).font(.headline)
                        Spacer()
                        Text("Trend \(repo.trendScore)").font(.caption.bold())
                            .padding(.horizontal, 7).padding(.vertical, 3)
                            .background(.quaternary, in: Capsule())
                    }
                    Text(repo.displayDescription).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
                    HStack(spacing: 12) {
                        Label(repo.stars.formatted(), systemImage: "star.fill")
                        Label(repo.forks.formatted(), systemImage: "tuningfork")
                        if let language = repo.language { Label(language, systemImage: "chevron.left.forwardslash.chevron.right") }
                    }.font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture { NSWorkspace.shared.open(repo.url) }
            }
        }
        .padding(22)
        .frame(minWidth: 650, minHeight: 520)
        .task { await refresh() }
    }

    private func refresh() async {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        loading = true; error = nil
        do {
            let repos = try await GitHubService.shared.search(query: query)
            repositories = repos
            SharedStore.defaults.set(query, forKey: SharedStore.queryKey)
            SharedStore.saveRepositories(repos)
        } catch {
            self.error = "GitHub request failed: \(error.localizedDescription)"
        }
        loading = false
    }
}
