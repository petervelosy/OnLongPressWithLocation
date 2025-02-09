// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "OnLongPressWithLocation",
    platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "OnLongPressWithLocation",
            targets: ["OnLongPressWithLocation"]),
    ],
    targets: [
        .target(
            name: "OnLongPressWithLocation"),
        .testTarget(
            name: "OnLongPressWithLocationTests",
            dependencies: ["OnLongPressWithLocation"]
        ),
    ]
)
