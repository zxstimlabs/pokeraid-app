import Testing
import PokeraidKit

@Test func rankingsAreBestFirst() {
    #expect(HandRanking.allCases.map(\.rawValue) == Array(1...10))
}

@Test(arguments: HandRanking.allCases)
func exampleIsTheHandItShows(_ ranking: HandRanking) {
    let (hand, kickers) = ranking.example
    #expect(hand.count + kickers.count == 5)
    #expect(Set(hand + kickers).count == 5, "Each card is in a deck once")
    #expect(HandRanking(hand + kickers) == ranking)
}

@Test func acePlaysLowInAStraight() {
    let wheel = [Card(.ace, .hearts), Card(.two, .clubs), Card(.three, .spades), Card(.four, .diamonds), Card(.five, .hearts)]
    #expect(HandRanking(wheel) == .straight)
}

@Test func aceLowStraightFlushIsNotRoyal() {
    let cards = [Card(.ace, .clubs), Card(.two, .clubs), Card(.three, .clubs), Card(.four, .clubs), Card(.five, .clubs)]
    #expect(HandRanking(cards) == .straightFlush)
}

@Test func straightsDontWrapAround() {
    let cards = [Card(.queen, .hearts), Card(.king, .clubs), Card(.ace, .spades), Card(.two, .diamonds), Card(.three, .hearts)]
    #expect(HandRanking(cards) == .highCard)
}
