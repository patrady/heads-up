import Foundation

enum CardStatus {
    case pending, correct, passed
}

struct RoundCard: Identifiable {
    let id: UUID = UUID()
    let word: String
    var status: CardStatus = .pending
}
