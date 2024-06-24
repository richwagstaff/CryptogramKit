// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CryptogramKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CryptogramKit",
            targets: ["CryptogramKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/richwagstaff/KeyboardKit", branch: "main"),
        .package(url: "https://github.com/richwagstaff/PuzzlestarAppUI", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CryptogramKit",
            dependencies: ["SnapKit", "KeyboardKit", "PuzzlestarAppUI"]),
        .testTarget(
            name: "CryptogramKitTests",
            dependencies: ["CryptogramKit"]),
    ])
