import SwiftUI

@main
struct PokeraidApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @AppStorage(AppAppearance.key) private var appearance = AppAppearance.system

    var body: some View {
        HomeView()
            .tint(Theme.accent)
            // Settings › Appearance. Theme's colors follow it.
            .appAppearance(appearance)
    }
}
