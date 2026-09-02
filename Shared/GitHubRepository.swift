import Foundation

struct GitHubRepository: Codable, Identifiable, Hashable {
    let id: Int
    let fullName: String
    let url: URL
    let description: String?
    let stars: Int
    let forks: Int
    let language: String?
    let updatedAt: Date

    var displayDescription: String {
        description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No description provided."
    }

    var trendScore: Int {
        let starSignal = log10(Double(max(stars, 1)) + 1) * 12
        let forkSignal = log10(Double(max(forks, 1)) + 1) * 8
        let ageHours = max(0, Date().timeIntervalSince(updatedAt) / 3600)
        let recency = max(0, 12 - ageHours / 2)
        return min(99, max(1, Int(starSignal + forkSignal + recency)))
    }
}

struct GitHubSearchResponse: Codable {
    let items: [GitHubRepositoryDTO]
}

struct GitHubRepositoryDTO: Codable {
    let id: Int
    let full_name: String
    let html_url: URL
    let description: String?
    let stargazers_count: Int
    let forks_count: Int
    let language: String?
    let updated_at: Date

    func model() -> GitHubRepository {
        GitHubRepository(id: id, fullName: full_name, url: html_url,
                         description: description, stars: stargazers_count,
                         forks: forks_count, language: language, updatedAt: updated_at)
    }
}
