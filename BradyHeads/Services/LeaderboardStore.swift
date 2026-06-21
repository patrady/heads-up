import Foundation

final class LeaderboardStore {
    static let shared = LeaderboardStore()
    private let key = "brady_heads_leaderboard"

    private init() {}

    func loadEntries() -> [LeaderboardEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data)
        else { return [] }
        return entries.sorted { $0.score > $1.score }
    }

    func save(_ entry: LeaderboardEntry) {
        var entries = loadEntries()
        entries.append(entry)
        if entries.count > 100 {
            entries = Array(entries.sorted { $0.score > $1.score }.prefix(100))
        }
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
