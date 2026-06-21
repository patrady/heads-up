import Foundation

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []

    func load() {
        entries = LeaderboardStore.shared.loadEntries()
    }

    func addEntry(playerName: String, score: Int, total: Int, deckName: String) {
        let entry = LeaderboardEntry(
            id: UUID(),
            playerName: playerName.trimmingCharacters(in: .whitespaces),
            score: score,
            total: total,
            deckName: deckName,
            date: Date()
        )
        LeaderboardStore.shared.save(entry)
        load()
    }
}
