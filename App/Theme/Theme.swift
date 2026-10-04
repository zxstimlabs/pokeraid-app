import SwiftUI
import UIKit

/// The app's colors, in two themes that follow the window's appearance (Settings › Appearance, `AppAppearance`).
/// A placeholder palette for now. Each color holds both themes (`Color(light:dark:)`), so views use `Theme` colors,
/// never `.white` or `.black`.
enum Theme {
    static let background = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x000000))
    /// Text and icons over the background.
    static let text = Color(light: .black, dark: .white)
    /// Buttons and links, applied as the app's tint.
    static let accent = Color(light: Color(hex: 0x0D7A4A), dark: Color(hex: 0x30C27B))
    /// Losing or giving up, like the Fold advice in Odds.
    static let danger = Color(light: Color(hex: 0xD70015), dark: Color(hex: 0xFF6961))

    /// A playing card's face and its edge. Dark mode dims the face rather than leaving a white card on black.
    static let cardFace = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x2C2C2E))
    static let cardEdge = Color(light: Color(hex: 0xD1D1D6), dark: Color(hex: 0x48484A))
    /// Hearts and diamonds.
    static let cardRed = Color(light: Color(hex: 0xD70015), dark: Color(hex: 0xFF6961))
    /// Spades and clubs. Light on the dark card face in dark mode.
    static let cardBlack = Color(light: Color(hex: 0x1C1C1E), dark: Color(hex: 0xF2F2F7))
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    /// `light` in light mode and `dark` in dark mode, resolved wherever the color is drawn.
    init(light: Color, dark: Color) {
        let (light, dark) = (UIColor(light), UIColor(dark))
        self.init(uiColor: UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}
