// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThunderBasics",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ThunderBasics",
            targets: [
                "ThunderBasicsSwift",
                "ThunderBasicsObjC",
            ]
        ),
        .library(
            name: "ThunderBasicsMac",
            targets: [
                "ThunderBasicsMac"
            ]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ThunderBasicsSwift",
            path: "ThunderBasicsSwift"
        ),
        .target(
            name: "ThunderBasicsObjC",
            path: "ThunderBasicsObjC"
        ),
        .target(
            name: "ThunderBasicsMac",
            path: "ThunderBasicsMac"
        ),
        .testTarget(
            name: "ThunderBasicsTests",
            dependencies: ["ThunderBasicsSwift"],
            path: "ThunderBasicsTests"
        ),
    ]
)
