import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var showClearConfirmation = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.entries.isEmpty {
                    ContentUnavailableView(
                        "No Scores Yet",
                        systemImage: "trophy",
                        description: Text("Play a round to get on the board!")
                    )
                } else {
                    List {
                        ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                            LeaderboardRowView(rank: index + 1, entry: entry)
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !viewModel.entries.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            showClearConfirmation = true
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .onAppear { viewModel.load() }
            .alert("Clear Leaderboard?", isPresented: $showClearConfirmation) {
                Button("Clear All", role: .destructive) {
                    LeaderboardStore.shared.clearAll()
                    viewModel.load()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("All scores will be permanently deleted.")
            }
        }
    }
}

private struct LeaderboardRowView: View {
    let rank: Int
    let entry: LeaderboardEntry

    var body: some View {
        HStack(spacing: 12) {
            rankBadge
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.playerName)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(entry.deckName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(scoreColor)
                Text("of \(entry.total)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var rankBadge: some View {
        ZStack {
            Circle()
                .fill(rankColor.opacity(0.15))
                .frame(width: 36, height: 36)
            Text(rankLabel)
                .font(.system(size: rank <= 3 ? 18 : 13, weight: .bold))
                .foregroundStyle(rankColor)
        }
    }

    private var rankLabel: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(rank)"
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(white: 0.6)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return .secondary
        }
    }

    private var scoreColor: Color {
        let ratio = entry.total > 0 ? Double(entry.score) / Double(entry.total) : 0
        if ratio >= 0.8 { return .green }
        if ratio >= 0.5 { return .orange }
        return .red
    }
}
