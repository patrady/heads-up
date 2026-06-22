import Foundation

final class DeckStore {
    static let shared = DeckStore()

    private let decksKey = "brady_heads_decks_v2"
    private let migratedKey = "brady_heads_decks_migrated_v2"

    private init() {
        migrateIfNeeded()
    }

    private func migrateIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: migratedKey) else { return }
        persist(DeckLibrary.all)
        UserDefaults.standard.set(true, forKey: migratedKey)
    }

    func loadDecks() -> [CardDeck] {
        guard let data = UserDefaults.standard.data(forKey: decksKey),
              let decks = try? JSONDecoder().decode([CardDeck].self, from: data)
        else { return DeckLibrary.all }
        return decks
    }

    func addDeck(_ deck: CardDeck) {
        var decks = loadDecks()
        decks.append(deck)
        persist(decks)
    }

    func updateDeck(_ deck: CardDeck) {
        var decks = loadDecks()
        guard let index = decks.firstIndex(where: { $0.id == deck.id }) else { return }
        decks[index] = deck
        persist(decks)
    }

    func deleteDeck(id: UUID) {
        var decks = loadDecks()
        decks.removeAll { $0.id == id }
        persist(decks)
    }

    private func persist(_ decks: [CardDeck]) {
        if let data = try? JSONEncoder().encode(decks) {
            UserDefaults.standard.set(data, forKey: decksKey)
        }
    }
}
