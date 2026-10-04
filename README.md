# PokerAid

A poker helper app for iPhone, native in SwiftUI. Scaffolded from `statemono-app`'s setup: XcodeGen, a SwiftUI app target and a local Swift package for everything that isn't UI.

The app is called PokerAid wherever people see its name: the home screen, the UI and docs. In code it stays `Pokeraid`: the target, scheme, `PokeraidKit` and the bundle ID `com.pokeraid`.

## Status

Early. Two tabs: Odds, where you choose a hand's cards street by street (pre-flop, flop, turn, river) and the number of opponents, and each street shows your chance of winning with advice to continue or fold, and Hands, the poker hand rankings from royal flush to high card, each with example cards. A gear in each tab opens Settings (Appearance: System, Light or Dark, and the version).

## Requirements

- iOS 18 or later.
- Xcode 16 or later. The project is built with Xcode 27.
- [XcodeGen](https://github.com/yonaskolb/XcodeGen).

## Setup

```sh
brew install xcodegen   # once
xcodegen generate       # creates Pokeraid.xcodeproj from project.yml
open Pokeraid.xcodeproj
```

Run the `Pokeraid` scheme.

The `.xcodeproj` is generated and not committed. Edit `project.yml` instead, and run `xcodegen generate` again after adding or removing files.

## Tests

```sh
cd Packages/PokeraidKit && swift test
```

## Layout

- `project.yml`: XcodeGen spec. Target `Pokeraid` (bundle ID `com.pokeraid`, iPhone only).
- `App/`: the SwiftUI app.
  - `Home/`: the first screen, the tab bar.
  - `Odds/`: the Odds tab.
  - `Rankings/`: the Hands tab, the hand rankings.
  - `Cards/`: playing cards drawn natively (`PlayingCard`, `CardPlaceholder`) and the sheet that picks one (`CardPicker`).
  - `Settings/`: the Settings sheet and its pages.
  - `Theme/`: colors (`Theme`, `Color(light:dark:)`).
  - `AppIcon.icon`: the app icon, a placeholder spade. Edit it in Icon Composer.
- `Packages/PokeraidKit/`: all non-UI logic, with tests: cards (`Card`), the hand rankings (`HandRanking`), the value of the best five of up to seven cards (`HandValue`), the cards of a hand by street (`Deal`, `Street`), and the odds and advice (`Odds`), worked out by dealing out the unknown cards 20,000 times. It also lists macOS as a platform so `swift test` runs on the Mac.
