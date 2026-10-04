import SwiftUI

/// The first screen. A placeholder until the app's features land, with the gear that opens Settings.
struct HomeView: View {
    @State private var showsSettings = false

    var body: some View {
        NavigationStack {
            ContentUnavailableView {
                Label("Pokeraid", systemImage: "suit.spade.fill")
            } description: {
                Text("Nothing here yet.")
            }
            .foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gearshape") {
                        showsSettings = true
                    }
                }
            }
        }
        .sheet(isPresented: $showsSettings) {
            SettingsView()
        }
    }
}

#Preview {
    HomeView()
}
