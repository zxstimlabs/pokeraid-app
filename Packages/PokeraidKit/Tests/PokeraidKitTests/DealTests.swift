import Testing
import PokeraidKit

@Test func streetsDealTwoThreeOneOne() {
    #expect(Street.allCases.map(\.cardCount) == [2, 3, 1, 1])
}

@Test func newDealKnowsNoCards() {
    let deal = Deal()
    #expect(deal.knownCards.isEmpty)
    for street in Street.allCases {
        for index in 0..<street.cardCount {
            #expect(deal[street, index] == nil)
        }
    }
}

@Test func dealingACardKnowsIt() {
    var deal = Deal()
    deal[.preflop, 1] = Card(.ace, .spades)
    deal[.river, 0] = Card(.two, .hearts)
    #expect(deal[.preflop, 1] == Card(.ace, .spades))
    #expect(deal.knownCards == [Card(.ace, .spades), Card(.two, .hearts)])
}

@Test func dealingACardAgainMovesIt() {
    var deal = Deal()
    deal[.preflop, 0] = Card(.ace, .spades)
    deal[.flop, 2] = Card(.ace, .spades)
    #expect(deal[.preflop, 0] == nil)
    #expect(deal[.flop, 2] == Card(.ace, .spades))
    #expect(deal.knownCards == [Card(.ace, .spades)])
}

@Test func cardsThroughAStreetOnceAllAreKnown() throws {
    var deal = Deal()
    deal[.preflop, 0] = Card(.ace, .spades)
    #expect(deal.cards(through: .preflop) == nil)
    deal[.preflop, 1] = Card(.king, .spades)
    let preflop = try #require(deal.cards(through: .preflop))
    #expect(preflop.hole == [Card(.ace, .spades), Card(.king, .spades)])
    #expect(preflop.board.isEmpty)

    deal[.flop, 0] = Card(.two, .hearts)
    deal[.flop, 1] = Card(.three, .hearts)
    deal[.turn, 0] = Card(.four, .hearts)
    #expect(deal.cards(through: .flop) == nil, "The flop isn't complete")
    #expect(deal.cards(through: .turn) == nil, "Nor is everything before the turn")
    deal[.flop, 2] = Card(.five, .hearts)
    #expect(deal.cards(through: .turn)?.board == [Card(.two, .hearts), Card(.three, .hearts), Card(.five, .hearts), Card(.four, .hearts)])
}

@Test func removingACardForgetsIt() {
    var deal = Deal()
    deal[.turn, 0] = Card(.king, .clubs)
    deal[.turn, 0] = nil
    #expect(deal.knownCards.isEmpty)
}
