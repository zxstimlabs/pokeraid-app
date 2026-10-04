/// How good the best five-card hand in some cards is. A better hand is greater, and hands that split the pot are equal.
public struct HandValue: Comparable, Hashable, Sendable {
    /// The ranking, 0 for high card to 9 for a royal flush, then the ranks that break ties, most important first, 4 bits
    /// each, 0 for a two to 12 for an ace.
    let score: Int

    /// The best hand in five to seven cards.
    public init(_ cards: some Collection<Card>) {
        precondition((5...7).contains(cards.count), "A hand is the best five of five to seven cards")
        self.init(cards: cards.reduce(0) { $0 | $1.bit })
    }

    /// The best hand in a set of cards, `Card.bit`s. Allocates nothing, for working out odds over many deals.
    init(cards: UInt64) {
        let a = UInt16(truncatingIfNeeded: cards)
        let b = UInt16(truncatingIfNeeded: cards >> 16)
        let c = UInt16(truncatingIfNeeded: cards >> 32)
        let d = UInt16(truncatingIfNeeded: cards >> 48)
        let all = a | b | c | d

        // In seven cards, a flush rules out four of a kind and a full house, so only a straight flush beats it.
        let flush = a.nonzeroBitCount >= 5 ? a : b.nonzeroBitCount >= 5 ? b : c.nonzeroBitCount >= 5 ? c : d.nonzeroBitCount >= 5 ? d : 0
        if flush != 0 {
            if let high = Self.straightHigh(flush) {
                var score = Score(high == 12 ? .royalFlush : .straightFlush)
                score.add(high)
                self.score = score.value
            } else {
                var score = Score(.flush)
                score.addHighest(5, of: flush)
                self.score = score.value
            }
            return
        }

        // Ranks held in all four suits, in three or more, in two or more.
        let quads = a & b & c & d
        let threes = (a & b & c) | (a & b & d) | (a & c & d) | (b & c & d)
        let pairs = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d)

        var score: Score
        if quads != 0 {
            score = Score(.fourOfAKind)
            let quad = Self.highest(quads)
            score.add(quad)
            score.addHighest(1, of: all & ~(1 << quad))
        } else if threes != 0, pairs & ~(1 << Self.highest(threes)) != 0 {
            score = Score(.fullHouse)
            let three = Self.highest(threes)
            score.add(three)
            // The best other pair, which can be a second three of a kind.
            score.add(Self.highest(pairs & ~(1 << three)))
        } else if let high = Self.straightHigh(all) {
            score = Score(.straight)
            score.add(high)
        } else if threes != 0 {
            score = Score(.threeOfAKind)
            let three = Self.highest(threes)
            score.add(three)
            score.addHighest(2, of: all & ~(1 << three))
        } else if pairs.nonzeroBitCount >= 2 {
            score = Score(.twoPair)
            let high = Self.highest(pairs)
            let low = Self.highest(pairs & ~(1 << high))
            score.add(high)
            score.add(low)
            score.addHighest(1, of: all & ~(1 << high) & ~(1 << low))
        } else if pairs != 0 {
            score = Score(.onePair)
            let pair = Self.highest(pairs)
            score.add(pair)
            score.addHighest(3, of: all & ~(1 << pair))
        } else {
            score = Score(.highCard)
            score.addHighest(5, of: all)
        }
        self.score = score.value
    }

    public var ranking: HandRanking {
        HandRanking(rawValue: 10 - (score >> 20))!
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.score < rhs.score
    }

    /// The highest rank in a set of ranks, a bit each.
    private static func highest(_ ranks: UInt16) -> Int {
        15 - ranks.leadingZeroBitCount
    }

    /// The top rank of the best straight in a set of ranks, if there's one.
    private static func straightHigh(_ ranks: UInt16) -> Int? {
        // A bit for each rank that tops five in a row.
        let tops = ranks & (ranks << 1) & (ranks << 2) & (ranks << 3) & (ranks << 4)
        if tops != 0 {
            return highest(tops)
        }
        // The wheel, A-2-3-4-5: the ace plays low, and the five is the top.
        let wheel: UInt16 = 0b1_0000_0000_1111
        return ranks & wheel == wheel ? 3 : nil
    }

    /// Builds a `score`: the ranking, then up to five ranks.
    private struct Score {
        private var packed: Int
        private var free = 5

        init(_ ranking: HandRanking) {
            packed = 10 - ranking.rawValue
        }

        var value: Int {
            packed << (4 * free)
        }

        mutating func add(_ rank: Int) {
            packed = packed << 4 | rank
            free -= 1
        }

        mutating func addHighest(_ count: Int, of ranks: UInt16) {
            var ranks = ranks
            for _ in 0..<count where ranks != 0 {
                let rank = HandValue.highest(ranks)
                add(rank)
                ranks &= ~(1 << rank)
            }
        }
    }
}

extension Card {
    /// The card as a bit in a set of cards: 16 bits a suit, and in a suit a bit a rank from the two up.
    var bit: UInt64 {
        1 << (16 * suit.rawValue + rank.rawValue - 2)
    }

    /// The 52 cards of a deck.
    static let deck = Suit.allCases.flatMap { suit in Rank.allCases.map { Card($0, suit) } }
}
