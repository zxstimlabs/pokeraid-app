import Testing
import PokeraidKit

/// Cards written short, like "As Td 2c": the rank, 2 to 9, T, J, Q, K or A, then the suit, s, h, d or c.
func cards(_ text: String) -> [Card] {
    text.split(separator: " ").map { code in
        let rank = Card.Rank.allCases[Array("23456789TJQKA").firstIndex(of: code.first!)!]
        let suit = Card.Suit.allCases[Array("shdc").firstIndex(of: code.last!)!]
        return Card(rank, suit)
    }
}

func value(_ text: String) -> HandValue {
    HandValue(cards(text))
}

@Test(arguments: [
    ("As Ks Qs Js Ts 2h 3d", HandRanking.royalFlush),
    ("9h 8h 7h 6h 5h Ac Ad", .straightFlush),
    ("Ah 2h 3h 4h 5h Kd Kc", .straightFlush),
    ("5c 5d 5h 5s 2c 3c 4d", .fourOfAKind),
    ("3c 3d 3h 9s 9c Ad Kd", .fullHouse),
    ("3c 3d 3h 9s 9c 9d Kd", .fullHouse),
    ("2d 7d 9d Jd Kd Ac Ah", .flush),
    ("9c Td Jh Qs Kc 2d 2h", .straight),
    ("Ac 2d 3h 4s 5c Kd Qh", .straight),
    ("7c 7d 7h Ks 2c 4d 9h", .threeOfAKind),
    ("7c 7d Kh Ks 2c 2d 9h", .twoPair),
    ("7c 7d Kh As 2c 4d 9h", .onePair),
    ("Qc Kd Ah 2s 3c 7d 9h", .highCard),
])
func bestFiveOfSeven(_ text: String, _ ranking: HandRanking) {
    #expect(value(text).ranking == ranking)
}

@Test func betterRankingWins() {
    #expect(value("2h 5h 7h 9h Jh") > value("Th Jd Qc Ks Ad"))
    #expect(value("2h 2d 2c 3s 3d") > value("Ah Kh Qh Jh 9h"))
}

@Test func kickersBreakTies() {
    #expect(value("Ah Ad Kc 7s 2d") > value("As Ac Qc 7s 2d"))
    #expect(value("Kh Kd 2c 2s 3d") > value("Qh Qd Jc Js Ad"))
    #expect(value("Kh Kd 9c 9s Ad") > value("Ks Kc 9h 9d Qd"))
    #expect(value("Ah Ad Ac 2s 2d") > value("Kh Kd Kc Qs Qd"))
}

@Test func wheelIsTheLowestStraight() {
    #expect(value("6h 5d 4c 3s 2d") > value("Ah 2d 3c 4s 5d"))
}

@Test func onlyTheBestFiveCount() {
    // A third pair only plays as a kicker, and a second three of a kind as the pair of a full house.
    #expect(value("Ah Ad Kh Kd Qh Qd 2c") == value("As Ac Ks Kc Qc"))
    #expect(value("Ah Ad Ac Kh Kd Kc 2s") == value("As Ad Ac Ks Kd"))
}

@Test func playingTheBoardSplits() {
    #expect(value("2c 3d Ah Kh Qd Jh 9c") == value("2h 4s Ah Kh Qd Jh 9c"))
}
