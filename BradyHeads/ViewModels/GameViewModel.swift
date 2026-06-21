import SwiftUI
import Combine

enum GamePhase {
    case waitingForFlat
    case countdown
    case playing
    case finished
}

@MainActor
final class GameViewModel: ObservableObject {
    let deck: CardDeck

    @Published var phase: GamePhase = .waitingForFlat
    @Published var cards: [RoundCard] = []
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var showCorrectOverlay: Bool = false
    @Published var showPassOverlay: Bool = false
    @Published var countdownValue: Int = 3

    private let motionManager = MotionManager()
    private let haptics = HapticManager.shared
    private var gameTimer: Timer?
    private var countdownTimer: Timer?

    var score: Int { cards.filter { $0.status == .correct }.count }
    var currentCard: RoundCard? {
        cards.indices.contains(currentIndex) ? cards[currentIndex] : nil
    }
    var playedCards: [RoundCard] {
        cards.filter { $0.status != .pending }
    }

    init(deck: CardDeck) {
        self.deck = deck
        self.cards = deck.cards.shuffled().map { RoundCard(word: $0) }
        setupMotionCallbacks()
    }

    func startWaitingForFlat() {
        #if targetEnvironment(simulator)
        // Simulator: skip flat detection and go straight to countdown
        beginCountdown()
        #else
        motionManager.startWatchingForFlat()
        #endif
    }

    private func setupMotionCallbacks() {
        motionManager.onPhoneFlat = { [weak self] in
            Task { @MainActor in self?.beginCountdown() }
        }
        motionManager.onCorrect = { [weak self] in
            Task { @MainActor in self?.markCorrect() }
        }
        motionManager.onPass = { [weak self] in
            Task { @MainActor in self?.markPass() }
        }
    }

    private func beginCountdown() {
        guard phase == .waitingForFlat else { return }
        phase = .countdown
        countdownValue = 3
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return timer.invalidate() }
            Task { @MainActor in
                if self.countdownValue > 1 {
                    self.countdownValue -= 1
                } else {
                    timer.invalidate()
                    self.startGame()
                }
            }
        }
    }

    private func startGame() {
        phase = .playing
        motionManager.startWatchingForTilts()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.timerTick() }
        }
    }

    private func timerTick() {
        guard phase == .playing else { return }
        timeRemaining -= 1

        if timeRemaining == 45 || timeRemaining == 30 || timeRemaining == 15 {
            haptics.timerMilestone()
        }
        if timeRemaining <= 5 && timeRemaining > 0 {
            haptics.timerTick()
        }
        if timeRemaining <= 0 {
            endGame()
        }
    }

    func markCorrect() {
        guard phase == .playing, currentCard != nil else { return }
        cards[currentIndex].status = .correct
        haptics.cardCorrect()
        showCorrectOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.showCorrectOverlay = false
            self?.advanceCard()
        }
    }

    func markPass() {
        guard phase == .playing, currentCard != nil else { return }
        cards[currentIndex].status = .passed
        haptics.cardPassed()
        showPassOverlay = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.showPassOverlay = false
            self?.advanceCard()
        }
    }

    private func advanceCard() {
        if currentIndex + 1 < cards.count {
            currentIndex += 1
        } else {
            endGame()
        }
    }

    private func endGame() {
        guard phase == .playing else { return }
        phase = .finished
        gameTimer?.invalidate()
        gameTimer = nil
        motionManager.stop()
        haptics.gameOver()
    }

    func restartWithSameDeck() {
        gameTimer?.invalidate()
        countdownTimer?.invalidate()
        motionManager.stop()
        cards = deck.cards.shuffled().map { RoundCard(word: $0) }
        currentIndex = 0
        timeRemaining = 60
        showCorrectOverlay = false
        showPassOverlay = false
        phase = .waitingForFlat
        startWaitingForFlat()
    }

    func cleanup() {
        gameTimer?.invalidate()
        countdownTimer?.invalidate()
        motionManager.stop()
    }

    deinit {
        gameTimer?.invalidate()
        countdownTimer?.invalidate()
    }
}
