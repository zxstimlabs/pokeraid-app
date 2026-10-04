/// A playing card from a standard 52-card deck.
public struct Card: Hashable, Sendable {
    public let rank: Rank
    public let suit: Suit

    public init(_ rank: Rank, _ suit: Suit) {
        self.rank = rank
        self.suit = suit
    }

    /// From two, the lowest, to ace, the highest. Raw values are the ranks' values: 2 to 10, then jack 11 to ace 14.
    public enum Rank: Int, CaseIterable, Sendable {
        case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    }

    public enum Suit: Int, CaseIterable, Sendable {
        case spades, hearts, diamonds, clubs
    }
}
