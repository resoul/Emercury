// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Emercury",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Emercury",
            targets: ["Emercury"]
        ),
    ],
    targets: [
        .target(
            name: "Emercury",
            dependencies: []
        ),
        .testTarget(
            name: "EmercuryTests",
            dependencies: ["Emercury"]
        ),
    ]
)
