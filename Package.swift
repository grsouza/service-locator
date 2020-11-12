// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceLocator",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "ServiceLocator",
            targets: ["ServiceLocator"]),
    ],
    dependencies: [
        .package(name: "ThreadSafe", url: "https://github.com/grsouza/swift-threadsafe", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ServiceLocator",
            dependencies: [
                .byName(name: "ThreadSafe")
            ]),
        .testTarget(
            name: "ServiceLocatorTests",
            dependencies: ["ServiceLocator"]),
    ],
    swiftLanguageVersions: [.v5]
)
