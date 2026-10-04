import PokeraidKit
import SwiftUI

/// A playing card drawn natively: its rank and suit in the top corner, and the suit large in the bottom one. A fixed
/// size, like a picture, so a row of five fits across the screen at any text size.
struct PlayingCard: View {
    let card: Card
    /// The card's width. Its height and everything on it scale with it.
    var width: CGFloat = 50

    var body: some View {
        // Sizes on the card are for the 50pt card.
        let scale = width / 50
        let shape = Self.shape(width: width)
        shape
            .fill(Theme.cardFace)
            .overlay { shape.strokeBorder(Theme.cardEdge, lineWidth: 1) }
            .overlay(alignment: .topLeading) {
                VStack(spacing: 1 * scale) {
                    Text(card.rank.symbol)
                        .font(.system(size: 17 * scale, weight: .semibold, design: .rounded))
                        .tracking(-0.5 * scale)
                    Image(systemName: card.suit.symbolName)
                        .font(.system(size: 10 * scale))
                }
                .padding(.top, 5 * scale)
                .padding(.leading, 5 * scale)
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: card.suit.symbolName)
                    .font(.system(size: 24 * scale))
                    .padding(6 * scale)
            }
            .foregroundStyle(card.suit.color)
            .frame(width: width, height: Self.height(width: width))
            .accessibilityElement()
            .accessibilityLabel(card.name)
    }

    /// A card's height for its width: 7 to 5, like a real one.
    static func height(width: CGFloat) -> CGFloat {
        width * 1.4
    }

    /// A card's outline, its corners rounding with its size.
    static func shape(width: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: width * 0.12, style: .continuous)
    }
}

/// Where a card goes before it's chosen: a card's outline, dashed, with a plus.
struct CardPlaceholder: View {
    var width: CGFloat = 50

    var body: some View {
        PlayingCard.shape(width: width)
            .strokeBorder(.tertiary, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
            .overlay {
                Image(systemName: "plus")
                    .font(.system(size: width * 0.4, weight: .medium))
                    .foregroundStyle(Theme.accent)
            }
            .frame(width: width, height: PlayingCard.height(width: width))
            .contentShape(PlayingCard.shape(width: width))
            .accessibilityElement()
            .accessibilityLabel("Choose a Card")
    }
}

extension Card {
    /// "10 of spades", "Ace of hearts": the card for VoiceOver.
    var name: String {
        let rank = switch rank {
        case .jack: String(localized: "Jack")
        case .queen: String(localized: "Queen")
        case .king: String(localized: "King")
        case .ace: String(localized: "Ace")
        default: rank.symbol
        }
        let suit = switch suit {
        case .spades: String(localized: "spades")
        case .hearts: String(localized: "hearts")
        case .diamonds: String(localized: "diamonds")
        case .clubs: String(localized: "clubs")
        }
        return String(localized: "\(rank) of \(suit)")
    }
}

extension Card.Rank {
    /// The rank as printed in a card's corner: 2 to 10, then J, Q, K and A.
    var symbol: String {
        switch self {
        case .jack: "J"
        case .queen: "Q"
        case .king: "K"
        case .ace: "A"
        default: "\(rawValue)"
        }
    }
}

extension Card.Suit {
    var title: LocalizedStringKey {
        switch self {
        case .spades: "Spades"
        case .hearts: "Hearts"
        case .diamonds: "Diamonds"
        case .clubs: "Clubs"
        }
    }

    var symbolName: String {
        switch self {
        case .spades: "suit.spade.fill"
        case .hearts: "suit.heart.fill"
        case .diamonds: "suit.diamond.fill"
        case .clubs: "suit.club.fill"
        }
    }

    var color: Color {
        switch self {
        case .hearts, .diamonds: Theme.cardRed
        case .spades, .clubs: Theme.cardBlack
        }
    }
}

#Preview {
    HStack(spacing: 6) {
        ForEach(Card.Suit.allCases, id: \.self) { suit in
            PlayingCard(card: Card(.ten, suit))
        }
        CardPlaceholder()
    }
}
