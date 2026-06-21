import Foundation

enum CardStatus {
    case pending, correct, passed
}

struct RoundCard: Identifiable {
    let id: UUID
    let word: String
    var status: CardStatus

    init(word: String) {
        self.id = UUID()
        self.word = word
        self.status = .pending
    }
}
