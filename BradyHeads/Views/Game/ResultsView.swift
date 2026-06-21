import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: GameViewModel
    @StateObject private var leaderboardVM = LeaderboardViewModel()
    @State private var playerName: String = ""
    @State private var didSave: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                scoreSummarySection
                leaderboardSection
                cardsSection
            }
            .navigationTitle("\(viewModel.deck.emoji) Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Play Again") {
                        viewModel.restartWithSameDeck()
                    }
                }
            }
        }
        .onAppear { unlockOrientation() }
    }

    private var scoreSummarySection: some View {
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.deck.name)
                        .font(.headline)
                    Text("Final Score")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(viewModel.score) / \(viewModel.playedCards.count)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
            }
            .padding(.vertical, 4)
        }
    }

    private var leaderboardSection: some View {
        Section("Save to Leaderboard") {
            if didSave {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Score saved!")
                        .foregroundStyle(.secondary)
                }
            } else {
                TextField("Enter your name", text: $playerName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)

                Button("Save Score") {
                    leaderboardVM.addEntry(
                        playerName: playerName,
                        score: viewModel.score,
                        total: viewModel.playedCards.count,
                        deckName: viewModel.deck.name
                    )
                    didSave = true
                }
                .disabled(playerName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var cardsSection: some View {
        Section("Cards") {
            ForEach(viewModel.cards) { card in
                HStack(spacing: 12) {
                    Image(systemName: iconName(for: card.status))
                        .foregroundStyle(iconColor(for: card.status))
                        .frame(width: 24)
                    Text(card.word)
                    Spacer()
                    Text(statusLabel(for: card.status))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func iconName(for status: CardStatus) -> String {
        switch status {
        case .correct: return "checkmark.circle.fill"
        case .passed: return "arrow.forward.circle"
        case .pending: return "circle.dotted"
        }
    }

    private func iconColor(for status: CardStatus) -> Color {
        switch status {
        case .correct: return .green
        case .passed: return .orange
        case .pending: return .secondary
        }
    }

    private func statusLabel(for status: CardStatus) -> String {
        switch status {
        case .correct: return "Correct"
        case .passed: return "Passed"
        case .pending: return "Not played"
        }
    }

    private func unlockOrientation() {
        AppDelegate.orientationLock = .portrait
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
    }
}
