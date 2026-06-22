import Foundation

@MainActor
final class DeckLibraryViewModel: ObservableObject {
    @Published var decks: [CardDeck] = []

    init() {
        load()
    }

    func load() {
        decks = DeckStore.shared.loadDecks()
    }

    func add(_ deck: CardDeck) {
        DeckStore.shared.addDeck(deck)
        load()
    }

    func update(_ deck: CardDeck) {
        DeckStore.shared.updateDeck(deck)
        load()
    }

    func delete(_ deck: CardDeck) {
        DeckStore.shared.deleteDeck(id: deck.id)
        load()
    }
}
