# Pokeraid

Native iOS app in SwiftUI. Scaffolded from `statemono-app`'s setup: XcodeGen, a SwiftUI app target and a local Swift package for everything that isn't UI.

## Status

Scaffold. The app launches to a placeholder home screen with a Settings sheet (Appearance: System, Light or Dark, and the version).

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
  - `Home/`: the first screen.
  - `Settings/`: the Settings sheet and its pages.
  - `Theme/`: colors (`Theme`, `Color(light:dark:)`).
  - `AppIcon.icon`: the app icon, a placeholder spade. Edit it in Icon Composer.
- `Packages/PokeraidKit/`: all non-UI logic, with tests. It also lists macOS as a platform so `swift test` runs on the Mac.
