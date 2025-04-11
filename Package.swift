// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ALKAsyncNetwork",
    platforms: [.iOS(.v13), .tvOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "ALKAsyncNetwork",
            type: .static,
            targets: ["ALKAsyncNetwork"]
        ),
    ],
    targets: [
        .target(
            name: "ALKAsyncNetwork"),

    ]
)
