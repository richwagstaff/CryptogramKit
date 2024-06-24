// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cryptogram",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Cryptogram",
            targets: ["Cryptogram"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/richwagstaff/KeyboardKit", branch: "cryptograms"),
        .package(url: "https://github.com/richwagstaff/PuzzlestarAppUI", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Cryptogram",
            dependencies: ["SnapKit", "KeyboardKit", "PuzzlestarAppUI"]),
        .testTarget(
            name: "CryptogramTests",
            dependencies: ["Cryptogram"]),
    ])
