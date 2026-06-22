import SwiftUI

struct HomeView: View {
    @StateObject private var libraryVM = DeckLibraryViewModel()
    @State private var showCreateSheet = false
    @State private var deckToEdit: CardDeck? = nil
    @State private var deckToDelete: CardDeck? = nil

    private let columns = [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(libraryVM.decks) { deck in
                        NavigationLink(destination: SetupView(deck: deck)) {
                            DeckCardView(deck: deck)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                deckToEdit = deck
                            } label: {
                                Label("Edit Deck", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                deckToDelete = deck
                            } label: {
                                Label("Delete Deck", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Brady Heads")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                DeckEditorView(mode: .create) { newDeck in
                    libraryVM.add(newDeck)
                }
            }
            .sheet(item: $deckToEdit) { deck in
                DeckEditorView(
                    mode: .edit(deck),
                    onSave: { updated in libraryVM.update(updated) },
                    onDelete: { libraryVM.delete(deck) }
                )
            }
            .alert("Delete Deck?", isPresented: Binding(
                get: { deckToDelete != nil },
                set: { if !$0 { deckToDelete = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let deck = deckToDelete { libraryVM.delete(deck) }
                    deckToDelete = nil
                }
                Button("Cancel", role: .cancel) { deckToDelete = nil }
            } message: {
                if let deck = deckToDelete {
                    Text("\"\(deck.name)\" will be permanently deleted.")
                }
            }
        }
    }
}
