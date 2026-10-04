import PokeraidKit
import SwiftUI

/// The ten poker hands, best first, each with five example cards and what makes it. The kickers, cards that aren't part
/// of the hand, are faded.
struct HandRankingsView: View {
    var body: some View {
        List(HandRanking.allCases) { ranking in
            HandRankingRow(ranking: ranking)
                .listRowBackground(Theme.background)
                // Lines only between hands: none above the first or below the last.
                .listRowSeparator(ranking == .royalFlush ? .hidden : .automatic, edges: .top)
                .listRowSeparator(ranking == .highCard ? .hidden : .automatic, edges: .bottom)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Theme.background)
        .foregroundStyle(Theme.text)
        .navigationTitle("Hand Rankings")
    }
}

private struct HandRankingRow: View {
    let ranking: HandRanking

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: "\(ranking.rawValue).circle.fill")
                .font(.title2)
                .accessibilityLabel(Text(ranking.rawValue, format: .number))
            VStack(alignment: .leading, spacing: 10) {
                Text(ranking.title)
                    .font(.headline)
                HStack(spacing: 6) {
                    ForEach(ranking.example.hand, id: \.self) { card in
                        PlayingCard(card: card)
                    }
                    ForEach(ranking.example.kickers, id: \.self) { card in
                        PlayingCard(card: card)
                            .opacity(0.3)
                    }
                }
                Text(ranking.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}

extension HandRanking {
    var title: LocalizedStringKey {
        switch self {
        case .royalFlush: "Royal Flush"
        case .straightFlush: "Straight Flush"
        case .fourOfAKind: "Four of a Kind"
        case .fullHouse: "Full House"
        case .flush: "Flush"
        case .straight: "Straight"
        case .threeOfAKind: "Three of a Kind"
        case .twoPair: "Two Pair"
        case .onePair: "One Pair"
        case .highCard: "High Card"
        }
    }

    /// What makes the hand.
    var summary: LocalizedStringKey {
        switch self {
        case .royalFlush: "The best hand in poker: ace, king, queen, jack and ten, all the same suit."
        case .straightFlush: "Five cards in sequence, all the same suit."
        case .fourOfAKind: "Four cards of the same rank."
        case .fullHouse: "Three of a kind and a pair."
        case .flush: "Five cards of the same suit, in any order."
        case .straight: "Five cards in sequence, of any suit."
        case .threeOfAKind: "Three cards of the same rank."
        case .twoPair: "Two different pairs."
        case .onePair: "Two cards of the same rank."
        case .highCard: "The worst hand in poker: no combination, so the highest card plays."
        }
    }
}

#Preview {
    NavigationStack {
        HandRankingsView()
    }
}
