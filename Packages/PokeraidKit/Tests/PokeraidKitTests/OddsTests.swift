import Testing
import PokeraidKit

@Test func acesWinAbout85PercentHeadsUp() async throws {
    let odds = try await Odds.calculate(hole: cards("Ah Ad"), board: [], opponents: 1)
    #expect(abs(odds.equity - 0.852) < 0.015)
}

@Test func sevenTwoWinsAboutAThirdHeadsUp() async throws {
    let odds = try await Odds.calculate(hole: cards("7h 2d"), board: [], opponents: 1)
    #expect(abs(odds.equity - 0.346) < 0.015)
}

@Test func moreOpponentsLowerTheOdds() async throws {
    let one = try await Odds.calculate(hole: cards("Ah Ad"), board: [], opponents: 1)
    let nine = try await Odds.calculate(hole: cards("Ah Ad"), board: [], opponents: 9)
    #expect(nine.equity < 0.4)
    #expect(nine.equity < one.equity)
}

@Test func theNutsOnTheRiverAlwaysWin() async throws {
    let odds = try await Odds.calculate(hole: cards("As Ks"), board: cards("Qs Js Ts 2h 3d"), opponents: 3)
    #expect(odds.equity == 1)
}

@Test(arguments: 1...3)
func aRoyalFlushOnTheBoardSplitsEveryPot(opponents: Int) async throws {
    let odds = try await Odds.calculate(hole: cards("2c 3d"), board: cards("As Ks Qs Js Ts"), opponents: opponents)
    #expect(abs(odds.equity - 1 / Double(opponents + 1)) < 1e-9)
}

@Test func sameCardsSameOdds() async throws {
    let first = try await Odds.calculate(hole: cards("Jc Tc"), board: cards("9c 2h 3d"), opponents: 2)
    let second = try await Odds.calculate(hole: cards("Jc Tc"), board: cards("9c 2h 3d"), opponents: 2)
    #expect(first == second)
}

@Test func adviceIsAFairShareOfThePot() {
    #expect(Odds(equity: 0.5, opponents: 1).advice == .continue)
    #expect(Odds(equity: 0.49, opponents: 1).advice == .fold)
    #expect(Odds(equity: 0.26, opponents: 3).advice == .continue)
    #expect(Odds(equity: 0.24, opponents: 3).advice == .fold)
}
