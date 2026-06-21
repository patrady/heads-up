import SwiftUI

struct HomeView: View {
    private let columns = [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(DeckLibrary.all) { deck in
                        NavigationLink(destination: SetupView(deck: deck)) {
                            DeckCardView(deck: deck)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Brady Heads")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
