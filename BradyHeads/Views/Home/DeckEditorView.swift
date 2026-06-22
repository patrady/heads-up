import SwiftUI

enum DeckEditorMode {
    case create
    case edit(CardDeck)
}

struct DeckEditorView: View {
    let mode: DeckEditorMode
    let onSave: (CardDeck) -> Void
    var onDelete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @FocusState private var newCardFocused: Bool

    @State private var name: String
    @State private var emoji: String
    @State private var selectedColor: DeckColor
    @State private var editableCards: [EditableCard]
    @State private var newCardText = ""
    @State private var showDeleteConfirmation = false

    private struct EditableCard: Identifiable {
        let id = UUID()
        var text: String
    }

    private static let presetEmojis = [
        "🎯", "⭐", "🔥", "💎", "🚀", "🌈", "🎮", "🎲",
        "🎵", "🎸", "🎨", "🎭", "📚", "🏆", "⚽", "🏀",
        "🐶", "🐱", "🦊", "🦁", "🐧", "🦋", "🦄", "🐻",
        "🍕", "🍔", "🎂", "🍦", "🌮", "🍎", "🌊", "⚡",
        "🌸", "🌍", "🎪", "💡", "🏠", "👑", "😄", "🎓"
    ]

    init(mode: DeckEditorMode, onSave: @escaping (CardDeck) -> Void, onDelete: (() -> Void)? = nil) {
        self.mode = mode
        self.onSave = onSave
        self.onDelete = onDelete
        switch mode {
        case .create:
            _name = State(initialValue: "")
            _emoji = State(initialValue: "")
            _selectedColor = State(initialValue: .blue)
            _editableCards = State(initialValue: [])
        case .edit(let deck):
            _name = State(initialValue: deck.name)
            _emoji = State(initialValue: deck.emoji)
            _selectedColor = State(initialValue: deck.colorName)
            _editableCards = State(initialValue: deck.cards.map { EditableCard(text: $0) })
        }
    }

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var existingDeckID: UUID? {
        if case .edit(let deck) = mode { return deck.id }
        return nil
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !emoji.isEmpty &&
        !editableCards.filter { !$0.text.trimmingCharacters(in: .whitespaces).isEmpty }.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                detailsSection
                colorSection
                cardsSection

                if isEditing {
                    Section {
                        Button("Delete Deck", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Deck" : "New Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .alert("Delete Deck?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    onDelete?()
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This deck will be permanently deleted.")
            }
        }
    }

    // MARK: - Sections

    private var detailsSection: some View {
        Section("Details") {
            TextField("Deck Name", text: $name)
            emojiPicker
        }
    }

    private var emojiPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Emoji")
                    .foregroundStyle(.secondary)
                Spacer()
                if !emoji.isEmpty {
                    Text(emoji)
                        .font(.title2)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 8) {
                ForEach(Self.presetEmojis, id: \.self) { e in
                    Button {
                        emoji = e
                    } label: {
                        Text(e)
                            .font(.system(size: 22))
                            .frame(width: 36, height: 36)
                            .background(emoji == e ? Color(.systemGray5) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(emoji == e ? Color.accentColor : Color.clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
        .padding(.vertical, 6)
    }

    private var colorSection: some View {
        Section("Color") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DeckColor.allCases, id: \.self) { deckColor in
                        colorSwatch(deckColor)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 2)
            }
        }
    }

    private func colorSwatch(_ deckColor: DeckColor) -> some View {
        let isSelected = selectedColor == deckColor
        return ZStack {
            Circle()
                .fill(deckColor.color)
                .frame(width: 38, height: 38)

            Circle()
                .strokeBorder(.white, lineWidth: 3)
                .frame(width: 38, height: 38)
                .opacity(isSelected ? 1 : 0)

            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .opacity(isSelected ? 1 : 0)
        }
        .shadow(
            color: deckColor.color.opacity(isSelected ? 0.5 : 0.2),
            radius: isSelected ? 6 : 2
        )
        .animation(.easeInOut(duration: 0.2), value: selectedColor)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedColor = deckColor
            }
        }
    }

    private var cardsSection: some View {
        Section {
            ForEach($editableCards) { $card in
                TextField("Card", text: $card.text)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            editableCards.removeAll { $0.id == $card.wrappedValue.id }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }

            HStack {
                TextField("New card...", text: $newCardText)
                    .onSubmit { addCard() }
                    .focused($newCardFocused)
                Button(action: addCard) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(selectedColor.color)
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .disabled(newCardText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        } header: {
            Text("Cards (\(editableCards.count))")
        }
    }

    // MARK: - Actions

    private func addCard() {
        let trimmed = newCardText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        editableCards.append(EditableCard(text: trimmed))
        newCardText = ""
        newCardFocused = true
    }

    private func save() {
        let trimmedCards = editableCards
            .map { $0.text.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        let deck = CardDeck(
            id: existingDeckID ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            emoji: emoji,
            colorName: selectedColor,
            cards: trimmedCards
        )
        onSave(deck)
        dismiss()
    }
}
