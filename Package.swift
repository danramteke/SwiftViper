// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftViper",
    dependencies: [
         .package(url: "https://github.com/kylef/Stencil.git", from: "0.8.0"),
         .package(url: "https://github.com/kylef/Commander", from: "0.6.1"),
         .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "SwiftViper",
            dependencies: ["Stencil", "StencilSwiftKit", "Commander"]),
    ]
)
