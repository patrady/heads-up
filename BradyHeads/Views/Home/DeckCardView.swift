import SwiftUI

struct DeckCardView: View {
    let deck: CardDeck

    var body: some View {
        VStack(spacing: 10) {
            Text(deck.emoji)
                .font(.system(size: 44))
            Text(deck.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text("\(deck.cards.count) cards")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(deck.color.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(deck.color.opacity(0.4), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
