/// The ten kinds of poker hand, best first: a hand beats every kind below it.
public enum HandRanking: Int, CaseIterable, Identifiable, Sendable {
    // Raw values are the places in the ranking, 1 the best.
    case royalFlush = 1
    case straightFlush
    case fourOfAKind
    case fullHouse
    case flush
    case straight
    case threeOfAKind
    case twoPair
    case onePair
    case highCard

    public var id: Self { self }

    /// The ranking of the best five-card hand in five to seven cards.
    public init(_ cards: [Card]) {
        self = HandValue(cards).ranking
    }

    /// Five cards that make this hand, to show it: the cards that make it, then the kickers, which only break ties.
    public var example: (hand: [Card], kickers: [Card]) {
        switch self {
        case .royalFlush:
            ([Card(.ten, .spades), Card(.jack, .spades), Card(.queen, .spades), Card(.king, .spades), Card(.ace, .spades)], [])
        case .straightFlush:
            ([Card(.six, .diamonds), Card(.seven, .diamonds), Card(.eight, .diamonds), Card(.nine, .diamonds), Card(.ten, .diamonds)], [])
        case .fourOfAKind:
            ([Card(.nine, .spades), Card(.nine, .diamonds), Card(.nine, .clubs), Card(.nine, .hearts)], [Card(.ace, .clubs)])
        case .fullHouse:
            ([Card(.ace, .diamonds), Card(.ace, .spades), Card(.ace, .clubs), Card(.seven, .clubs), Card(.seven, .hearts)], [])
        case .flush:
            ([Card(.three, .diamonds), Card(.eight, .diamonds), Card(.six, .diamonds), Card(.king, .diamonds), Card(.ten, .diamonds)], [])
        case .straight:
            ([Card(.seven, .spades), Card(.eight, .diamonds), Card(.nine, .clubs), Card(.ten, .hearts), Card(.jack, .spades)], [])
        case .threeOfAKind:
            ([Card(.ten, .spades), Card(.ten, .diamonds), Card(.ten, .clubs)], [Card(.six, .hearts), Card(.ace, .spades)])
        case .twoPair:
            ([Card(.six, .spades), Card(.six, .diamonds), Card(.queen, .spades), Card(.queen, .hearts)], [Card(.king, .spades)])
        case .onePair:
            ([Card(.jack, .diamonds), Card(.jack, .spades)], [Card(.two, .clubs), Card(.nine, .hearts), Card(.king, .spades)])
        case .highCard:
            ([Card(.king, .hearts)], [Card(.seven, .diamonds), Card(.eight, .clubs), Card(.jack, .spades), Card(.ten, .hearts)])
        }
    }
}
