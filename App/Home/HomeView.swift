import SwiftUI

/// The first screen: the tab bar, with Odds first and Hands, the hand rankings, second. Each tab has the gear that opens
/// Settings.
struct HomeView: View {
    @State private var showsSettings = false

    var body: some View {
        TabView {
            Tab("Odds", systemImage: "percent") {
                NavigationStack {
                    OddsView()
                        .settingsButton($showsSettings)
                }
            }
            Tab("Hands", systemImage: "suit.spade.fill") {
                NavigationStack {
                    HandRankingsView()
                        .settingsButton($showsSettings)
                }
            }
        }
        .sheet(isPresented: $showsSettings) {
            SettingsView()
        }
    }
}

private extension View {
    /// The gear in a tab's navigation bar that opens Settings.
    func settingsButton(_ showsSettings: Binding<Bool>) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gearshape") {
                    showsSettings.wrappedValue = true
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
