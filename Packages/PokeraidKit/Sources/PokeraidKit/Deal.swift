/// A stage of a hand of Texas hold'em, named for the cards it deals: your two hole cards pre-flop, then the board's
/// three-card flop, the turn and the river.
public enum Street: Int, CaseIterable, Identifiable, Sendable {
    case preflop, flop, turn, river

    public var id: Self { self }

    /// How many cards the street deals.
    public var cardCount: Int {
        switch self {
        case .preflop: 2
        case .flop: 3
        case .turn, .river: 1
        }
    }
}

/// The cards of a hand of hold'em known so far, street by street. Each place on a street holds a card, or nil while it
/// isn't known, and a card can only be in one place.
public struct Deal: Equatable, Sendable {
    private var cards = Street.allCases.map { [Card?](repeating: nil, count: $0.cardCount) }

    public init() {}

    /// The card in a place on a street, `index` from 0 to below the street's `cardCount`. Setting a card that's already
    /// in another place moves it here.
    public subscript(street: Street, index: Int) -> Card? {
        get { cards[street.rawValue][index] }
        set {
            if let newValue {
                for street in cards.indices {
                    if let index = cards[street].firstIndex(of: newValue) {
                        cards[street][index] = nil
                    }
                }
            }
            cards[street.rawValue][index] = newValue
        }
    }

    /// Every card known so far.
    public var knownCards: Set<Card> {
        Set(cards.joined().compactMap { $0 })
    }

    /// Your two hole cards and the board up to and including a street, the cards to work out the odds on that street.
    /// Nil until they're all known.
    public func cards(through street: Street) -> (hole: [Card], board: [Card])? {
        let places = cards[...street.rawValue].joined()
        let known = places.compactMap { $0 }
        guard known.count == places.count else { return nil }
        return (Array(known.prefix(2)), Array(known.dropFirst(2)))
    }
}
