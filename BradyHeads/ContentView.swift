import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Decks", systemImage: "square.grid.2x2.fill")
                }

            LeaderboardView()
                .tabItem {
                    Label("Scores", systemImage: "trophy.fill")
                }
        }
    }
}
