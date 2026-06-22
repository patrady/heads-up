import SwiftUI

enum DeckColor: String, CaseIterable, Codable {
    case red, orange, yellow, green, teal, blue, indigo, purple, pink, brown

    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .teal: return .teal
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        }
    }

    var displayName: String { rawValue.capitalized }
}

struct CardDeck: Identifiable, Codable {
    let id: UUID
    var name: String
    var emoji: String
    var colorName: DeckColor
    var cards: [String]

    var color: Color { colorName.color }

    init(id: UUID = UUID(), name: String, emoji: String, colorName: DeckColor, cards: [String]) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.colorName = colorName
        self.cards = cards
    }
}
