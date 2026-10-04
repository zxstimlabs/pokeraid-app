/// Your chance of winning a hand of hold'em against other players' unknown cards, and whether to play on.
public struct Odds: Equatable, Sendable {
    /// Your share of the pot on average, from 0 to 1: the deals you win, plus your share of the ones you split.
    public let equity: Double
    /// How many players' unknown hands you're up against.
    public let opponents: Int

    public init(equity: Double, opponents: Int) {
        self.equity = equity
        self.opponents = opponents
    }

    /// Continue while your chance of winning is at least your fair share of the pot, 1 in the number of players, and
    /// fold below it. Simple on purpose: it leaves out the bets and the size of the pot.
    public var advice: Advice {
        equity >= 1 / Double(opponents + 1) ? .continue : .fold
    }

    public enum Advice: Sendable {
        case `continue`
        case fold
    }

    /// The odds of your two hole cards with the board known so far, none to five cards, against `opponents` players:
    /// the unknown cards, the rest of the board and the opponents' hands, dealt out `trials` times. The same cards give
    /// the same odds, and it stops early if the task is cancelled.
    @concurrent
    public static func calculate(hole: [Card], board: [Card], opponents: Int, trials: Int = 20_000) async throws -> Odds {
        var random = SplitMix64(seed: 0x5EED)
        return try simulate(hole: hole, board: board, opponents: opponents, trials: trials, using: &random)
    }

    static func simulate(
        hole: [Card],
        board: [Card],
        opponents: Int,
        trials: Int,
        using random: inout some RandomNumberGenerator
    ) throws -> Odds {
        precondition(hole.count == 2 && board.count <= 5, "Two hole cards and up to five on the board")
        precondition((1...9).contains(opponents), "One to nine opponents, ten players at most")
        let known = hole + board
        let mine = hole.reduce(0) { $0 | $1.bit }
        let shown = board.reduce(0) { $0 | $1.bit }
        var deck = Card.deck.filter { !known.contains($0) }.map(\.bit)
        let missing = 5 - board.count

        var share = 0.0
        for trial in 0..<trials {
            if trial.isMultiple(of: 1024) {
                try Task.checkCancellation()
            }
            // Deal the unknown cards off the top of a partly shuffled deck: the rest of the board, then two a player.
            for card in 0..<missing + 2 * opponents {
                deck.swapAt(card, Int.random(in: card..<deck.count, using: &random))
            }
            var board = shown
            for card in 0..<missing {
                board |= deck[card]
            }
            let me = HandValue(cards: mine | board)
            // The best opponent's hand, and how many have it.
            var best = HandValue(cards: board | deck[missing] | deck[missing + 1])
            var tied = 1
            for opponent in 1..<opponents {
                let card = missing + 2 * opponent
                let hand = HandValue(cards: board | deck[card] | deck[card + 1])
                if hand > best {
                    best = hand
                    tied = 1
                } else if hand == best {
                    tied += 1
                }
            }
            if me > best {
                share += 1
            } else if me == best {
                share += 1 / Double(tied + 1)
            }
        }
        return Odds(equity: share / Double(trials), opponents: opponents)
    }
}

/// A small, fast random number generator that repeats its sequence for a seed (SplitMix64).
struct SplitMix64: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
