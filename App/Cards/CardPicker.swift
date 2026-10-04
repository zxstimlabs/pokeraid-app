import PokeraidKit
import SwiftUI

/// A sheet to choose a card: the 52, by suit and aces first. Cards already dealt elsewhere are faded and can't be chosen.
/// When the place has a card, it's outlined, and Remove Card empties the place.
struct CardPicker: View {
    @Binding var card: Card?
    /// Every card dealt so far, `card` included.
    let dealt: Set<Card>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                ForEach(Card.Suit.allCases, id: \.self) { suit in
                    Section {
                        SuitGrid(suit: suit, chosen: card, isDealtElsewhere: { $0 != card && dealt.contains($0) }) {
                            card = $0
                            dismiss()
                        }
                    } header: {
                        Label(suit.title, systemImage: suit.symbolName)
                    }
                }
                if card != nil {
                    Section {
                        Button("Remove Card", role: .destructive) {
                            card = nil
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Choose a Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

/// A suit's 13 cards, ace to two, in rows of seven that fill the width.
private struct SuitGrid: View {
    let suit: Card.Suit
    let chosen: Card?
    let isDealtElsewhere: (Card) -> Bool
    let choose: (Card) -> Void
    @State private var cardWidth: CGFloat = 40

    private static let columns = 7
    private static let spacing: CGFloat = 6

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: Self.spacing), count: Self.columns),
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(Card.Rank.allCases.reversed(), id: \.self) { rank in
                let card = Card(rank, suit)
                Button {
                    choose(card)
                } label: {
                    PlayingCard(card: card, width: cardWidth)
                        .overlay {
                            if card == chosen {
                                PlayingCard.shape(width: cardWidth).strokeBorder(Theme.accent, lineWidth: 3)
                            }
                        }
                }
                .buttonStyle(.plain)
                .disabled(isDealtElsewhere(card))
                .opacity(isDealtElsewhere(card) ? 0.3 : 1)
                .accessibilityAddTraits(card == chosen ? .isSelected : [])
            }
        }
        .padding(.vertical, 4)
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width in
            cardWidth = (width - Self.spacing * CGFloat(Self.columns - 1)) / CGFloat(Self.columns)
        }
    }
}

#Preview {
    CardPicker(card: .constant(Card(.ace, .hearts)), dealt: [Card(.ace, .hearts), Card(.king, .spades)])
}
