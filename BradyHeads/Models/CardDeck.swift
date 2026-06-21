import SwiftUI

struct CardDeck: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let color: Color
    let cards: [String]

    init(name: String, emoji: String, color: Color, cards: [String]) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.color = color
        self.cards = cards
    }
}
