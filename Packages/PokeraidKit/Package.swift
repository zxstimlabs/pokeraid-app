// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PokeraidKit",
    // macOS too, so `swift test` runs on the Mac.
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "PokeraidKit", targets: ["PokeraidKit"]),
    ],
    targets: [
        .target(name: "PokeraidKit"),
        .testTarget(name: "PokeraidKitTests", dependencies: ["PokeraidKit"]),
    ]
)
