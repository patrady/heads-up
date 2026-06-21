import UIKit

final class HapticManager {
    static let shared = HapticManager()

    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()

    private init() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        notificationGenerator.prepare()
    }

    func timerTick() {
        lightGenerator.impactOccurred()
    }

    func timerMilestone() {
        mediumGenerator.impactOccurred()
    }

    func gameOver() {
        heavyGenerator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.heavyGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.heavyGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.heavyGenerator.impactOccurred()
        }
    }

    func cardCorrect() {
        notificationGenerator.notificationOccurred(.success)
    }

    func cardPassed() {
        notificationGenerator.notificationOccurred(.warning)
    }
}
