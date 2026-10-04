import SwiftUI
import UIKit

/// Light or dark, chosen in Settings › Appearance and kept per device. System follows the device.
enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    /// The `UserDefaults` key, read with `@AppStorage`.
    static let key = "appearance"

    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    /// For a window's `overrideUserInterfaceStyle`: unspecified follows the system.
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: .unspecified
        case .light: .light
        case .dark: .dark
        }
    }
}

extension View {
    /// Applies Settings › Appearance to the window, and with it to everything `Theme` draws and to sheets. Not
    /// `preferredColorScheme`: on iOS 18, going back to the system's appearance (nil) left an open sheet in the old one.
    /// The window's own override reaches the sheet as the system passes it down.
    func appAppearance(_ appearance: AppAppearance) -> some View {
        background { WindowStyle(style: appearance.interfaceStyle) }
    }
}

/// Sets its window's `overrideUserInterfaceStyle`.
private struct WindowStyle: UIViewRepresentable {
    let style: UIUserInterfaceStyle

    func makeUIView(context: Context) -> StyleView {
        StyleView()
    }

    func updateUIView(_ view: StyleView, context: Context) {
        view.style = style
    }

    final class StyleView: UIView {
        var style = UIUserInterfaceStyle.unspecified {
            didSet { window?.overrideUserInterfaceStyle = style }
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            window?.overrideUserInterfaceStyle = style
        }
    }
}

/// Settings › Appearance: the choice between System, Light and Dark, as a native inline picker.
struct AppearanceSettings: View {
    @AppStorage(AppAppearance.key) private var appearance = AppAppearance.system

    var body: some View {
        Form {
            Section {
                Picker("Appearance", selection: $appearance) {
                    ForEach(AppAppearance.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            } footer: {
                Text("System matches the appearance set in Settings on this iPhone.")
            }
        }
        .settingsPage("Appearance")
    }
}
