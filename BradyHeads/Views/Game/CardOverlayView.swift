import SwiftUI

struct CardOverlayView: View {
    let isCorrect: Bool
    let isVisible: Bool

    var body: some View {
        if isVisible {
            ZStack {
                (isCorrect ? Color.green : Color.orange)
                    .ignoresSafeArea()
                    .opacity(0.9)

                VStack(spacing: 20) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "arrow.forward.circle.fill")
                        .font(.system(size: 90))
                        .foregroundStyle(.white)

                    Text(isCorrect ? "CORRECT!" : "PASS")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .transition(.opacity.animation(.easeInOut(duration: 0.15)))
        }
    }
}
