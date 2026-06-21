import SwiftUI

struct SetupView: View {
    let deck: CardDeck
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    init(deck: CardDeck) {
        self.deck = deck
        _viewModel = StateObject(wrappedValue: GameViewModel(deck: deck))
    }

    var body: some View {
        Group {
            switch viewModel.phase {
            case .waitingForFlat:
                waitingView
                    .navigationBarTitleDisplayMode(.inline)
            case .countdown:
                countdownView
                    .navigationBarHidden(true)
            case .playing, .finished:
                GameView(viewModel: viewModel)
                    .navigationBarHidden(true)
            }
        }
        .onAppear { viewModel.startWaitingForFlat() }
        .onDisappear { viewModel.cleanup() }
    }

    private var waitingView: some View {
        ZStack {
            deck.color.opacity(0.07).ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Text(deck.emoji)
                    .font(.system(size: 64))

                Text(deck.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(deck.color)

                Divider()
                    .padding(.horizontal, 60)

                VStack(spacing: 16) {
                    Image(systemName: "iphone.landscape")
                        .font(.system(size: 72))
                        .foregroundStyle(deck.color)
                        .symbolEffect(.pulse, options: .repeating)

                    Text("Place your phone on your forehead")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Hold it flat with the screen facing up.\nThe game starts automatically!")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)

                Spacer()

                #if targetEnvironment(simulator)
                Text("Simulator: Game starts automatically")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 40)
                #endif
            }
        }
    }

    private var countdownView: some View {
        ZStack {
            deck.color.opacity(0.15).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Get ready!")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("\(viewModel.countdownValue)")
                    .font(.system(size: 160, weight: .black, design: .rounded))
                    .foregroundStyle(deck.color)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.4), value: viewModel.countdownValue)
            }
        }
    }
}
