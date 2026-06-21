import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let playerName: String
    let score: Int
    let total: Int
    let deckName: String
    let date: Date
}
