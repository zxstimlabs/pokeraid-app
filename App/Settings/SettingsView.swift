import SwiftUI

/// Settings, a sheet opened by the home screen's gear. Its first page lists the sections, each opening its own page,
/// like the system's Settings.
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppAppearance.key) private var appearance = AppAppearance.system

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        AppearanceSettings()
                    } label: {
                        LabeledContent {
                            Text(appearance.title)
                        } label: {
                            SettingsLabel("Appearance", systemImage: "circle.lefthalf.filled", color: Color(hex: 0x32ADE6))
                        }
                    }
                }
                Section {
                    LabeledContent("Version", value: Self.version)
                }
            }
            .settingsPage("Settings")
        }
        // Inside a pushed page, `dismiss` would only go back a page.
        .environment(\.closeSettings, dismiss)
    }

    /// "0.1.0 (1)", from project.yml's `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`.
    private static let version: String = {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }()
}

/// A section's row title with its icon: a white symbol on a colored rounded square, like the rows in the system's
/// Settings (30pt, corner radius 8).
private struct SettingsLabel: View {
    let title: LocalizedStringKey
    let systemImage: String
    let color: Color

    init(_ title: LocalizedStringKey, systemImage: String, color: Color) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
    }

    var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(color, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

extension View {
    /// A Settings page's title, and the Done button that closes the sheet from any page.
    func settingsPage(_ title: LocalizedStringKey) -> some View {
        modifier(SettingsPage(title: title))
    }
}

private struct SettingsPage: ViewModifier {
    let title: LocalizedStringKey
    @Environment(\.closeSettings) private var closeSettings

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { closeSettings?() }
                }
            }
    }
}

extension EnvironmentValues {
    /// Closes the Settings sheet from any of its pages: the sheet's own `dismiss`.
    @Entry var closeSettings: DismissAction?
}
