import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    var onEnd: () -> Void

    @State private var showEndConfirmation = false

    var body: some View {
        ZStack {
            if viewModel.phase == .finished {
                ResultsView(viewModel: viewModel)
            } else {
                gameplayContent
                    .navigationBarHidden(true)
            }
        }
        .onAppear { lockToLandscape() }
        .onDisappear {
            if viewModel.phase != .finished {
                unlockOrientation()
            }
        }
        .alert("End Game?", isPresented: $showEndConfirmation) {
            Button("End Game", role: .destructive) { onEnd() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your current game will be lost.")
        }
    }

    private var gameplayContent: some View {
        ZStack {
            viewModel.deck.color
                .ignoresSafeArea()

            VStack(spacing: 0) {
                timerBar
                Spacer()
                wordCard
                Spacer()
                tiltHints
            }

            #if targetEnvironment(simulator)
            simulatorControls
            #endif
        }
    }

    private var timerBar: some View {
        HStack {
            Button("End") { showEndConfirmation = true }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))
                .padding(.leading, 20)
                .padding(.top, 16)

            Spacer()
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / 60.0)
                    .stroke(
                        timerColor,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: viewModel.timeRemaining)
                Text("\(viewModel.timeRemaining)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 20)
            .padding(.top, 16)
        }
    }

    private var timerColor: Color {
        if viewModel.timeRemaining <= 5 { return .red }
        if viewModel.timeRemaining <= 15 { return .orange }
        return .white
    }

    private var wordCard: some View {
        VStack(spacing: 16) {
            if viewModel.showCorrectOverlay {
                feedbackLabel(isCorrect: true)
            } else if viewModel.showPassOverlay {
                feedbackLabel(isCorrect: false)
            } else if let card = viewModel.currentCard {
                Text(card.word)
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.3)
                    .lineLimit(3)
                    .padding(.horizontal, 32)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                    .id(card.id)
            }
        }
    }

    @ViewBuilder
    private func feedbackLabel(isCorrect: Bool) -> some View {
        VStack(spacing: 12) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "arrow.forward.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.white)
            Text(isCorrect ? "CORRECT!" : "PASS")
                .font(.system(size: 52, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private var tiltHints: some View {
        HStack {
            Label("PASS", systemImage: "arrow.up")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.leading, 24)
                .padding(.bottom, 20)

            Spacer()

            Label("CORRECT", systemImage: "arrow.down")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.6))
                .padding(.trailing, 24)
                .padding(.bottom, 20)
        }
    }

    #if targetEnvironment(simulator)
    private var simulatorControls: some View {
        VStack {
            Spacer()
            HStack(spacing: 20) {
                Button {
                    viewModel.markPass()
                } label: {
                    Label("Pass", systemImage: "arrow.forward")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }

                Button {
                    viewModel.markCorrect()
                } label: {
                    Label("Correct", systemImage: "checkmark")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 60)
        }
    }
    #endif

    private func lockToLandscape() {
        AppDelegate.orientationLock = .landscapeRight
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
    }

    private func unlockOrientation() {
        AppDelegate.orientationLock = .portrait
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
    }
}
