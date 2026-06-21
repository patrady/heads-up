import CoreMotion
import Foundation

final class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var debounceTimer: Timer?
    private var isDebouncing = false
    private var flatDuration: TimeInterval = 0
    private var lastUpdateTime: Date = .now

    @Published var isPhoneFlat: Bool = false

    var onPhoneFlat: (() -> Void)?
    var onCorrect: (() -> Void)?
    var onPass: (() -> Void)?

    private let correctThreshold: Double = -0.5
    private let passThreshold: Double = 0.5
    private let flatZThreshold: Double = 0.8
    private let flatRequiredDuration: TimeInterval = 1.0
    private let debounceDuration: TimeInterval = 0.8

    var isAvailable: Bool {
        motionManager.isAccelerometerAvailable
    }

    func startWatchingForFlat() {
        #if targetEnvironment(simulator)
        return
        #else
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        flatDuration = 0
        lastUpdateTime = .now
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }
            let z = data.acceleration.z
            let now = Date()
            let delta = now.timeIntervalSince(self.lastUpdateTime)
            self.lastUpdateTime = now

            if abs(z) > self.flatZThreshold {
                self.flatDuration += delta
                if self.flatDuration >= self.flatRequiredDuration && !self.isPhoneFlat {
                    self.isPhoneFlat = true
                    self.onPhoneFlat?()
                }
            } else {
                self.flatDuration = 0
                self.isPhoneFlat = false
            }
        }
        #endif
    }

    func startWatchingForTilts() {
        #if targetEnvironment(simulator)
        return
        #else
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.stopAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data, !self.isDebouncing else { return }
            let y = data.acceleration.y
            if y < self.correctThreshold {
                self.trigger(.correct)
            } else if y > self.passThreshold {
                self.trigger(.pass)
            }
        }
        #endif
    }

    func stop() {
        motionManager.stopAccelerometerUpdates()
        debounceTimer?.invalidate()
        isDebouncing = false
        flatDuration = 0
        isPhoneFlat = false
    }

    private enum TriggerDirection { case correct, pass }

    private func trigger(_ direction: TriggerDirection) {
        isDebouncing = true
        switch direction {
        case .correct: onCorrect?()
        case .pass: onPass?()
        }
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceDuration, repeats: false) { [weak self] _ in
            self?.isDebouncing = false
        }
    }
}
