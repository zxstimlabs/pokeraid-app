import PokeraidKit
import SwiftUI

/// The Odds tab: a hand's cards street by street, pre-flop to river. Each place is a dashed outline until its card is
/// chosen; tapping it opens the card picker. Once a street's cards and every earlier street's are known, its header
/// shows your odds of winning and whether to continue or fold.
struct OddsView: View {
    @State private var deal = Deal()
    @State private var choosing: Place?
    /// How many players' hands the odds are against. Kept between launches, as the table rarely changes.
    @AppStorage("opponents") private var opponents = 1

    var body: some View {
        List {
            Section {
                Stepper(value: $opponents, in: 1...9) {
                    LabeledContent("Opponents") {
                        Text(opponents, format: .number)
                    }
                }
            } footer: {
                Text("Odds are your chance of winning against ^[\(opponents) opponent](inflect: true). Continue while they're at least your fair share of the pot, 1 in \(opponents + 1), and fold below it.")
            }
            ForEach(Street.allCases) { street in
                Section {
                    HStack(spacing: 8) {
                        ForEach(0..<street.cardCount, id: \.self) { index in
                            Button {
                                choosing = Place(street: street, index: index)
                            } label: {
                                if let card = deal[street, index] {
                                    PlayingCard(card: card, width: Self.cardWidth)
                                } else {
                                    CardPlaceholder(width: Self.cardWidth)
                                }
                            }
                            // Not the row's button: each place takes its own taps.
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    HStack {
                        Text(street.title)
                        Spacer()
                        if let cards = deal.cards(through: street) {
                            StreetOdds(question: .init(hole: cards.hole, board: cards.board, opponents: opponents))
                        }
                    }
                }
            }
        }
        .navigationTitle("Odds")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Clear") { deal = Deal() }
                    .disabled(deal.knownCards.isEmpty)
            }
        }
        .sheet(item: $choosing) { place in
            CardPicker(card: $deal[place.street, place.index], dealt: deal.knownCards)
        }
    }

    private static let cardWidth: CGFloat = 56

    /// A place for a card on a street, the one being chosen.
    private struct Place: Hashable, Identifiable {
        let street: Street
        let index: Int

        var id: Self { self }
    }
}

/// A street's odds and advice, worked out again whenever its cards or the opponents change.
private struct StreetOdds: View {
    let question: Question
    @State private var odds: Odds?

    var body: some View {
        HStack(spacing: 8) {
            if let odds {
                Text(odds.equity, format: .percent.precision(.fractionLength(0)))
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(Theme.text)
                let color = odds.advice == .continue ? Theme.accent : Theme.danger
                Text(odds.advice.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(color.opacity(0.15), in: .capsule)
            } else {
                ProgressView()
            }
        }
        // Not the header's capitals, on iOS 18.
        .textCase(nil)
        .task(id: question) {
            odds = nil
            let odds = try? await Odds.calculate(hole: question.hole, board: question.board, opponents: question.opponents)
            if !Task.isCancelled {
                self.odds = odds
            }
        }
    }

    struct Question: Hashable {
        let hole: [Card]
        let board: [Card]
        let opponents: Int
    }
}

extension Odds.Advice {
    var title: LocalizedStringKey {
        switch self {
        case .continue: "Continue"
        case .fold: "Fold"
        }
    }
}

extension Street {
    var title: LocalizedStringKey {
        switch self {
        case .preflop: "Pre-flop"
        case .flop: "Flop"
        case .turn: "Turn"
        case .river: "River"
        }
    }
}

#Preview {
    NavigationStack {
        OddsView()
    }
}
