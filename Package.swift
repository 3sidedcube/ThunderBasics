// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThunderBasics",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ThunderBasics",
            targets: [
                "ThunderBasics"
            ]
        )
    ],
    targets: [
        .target(
            name: "ThunderBasics",
            dependencies: [
                .target(name: "ThunderBasicsObjC")
            ],
            path: "ThunderBasicsSwift"
        ),
        .target(
            name: "ThunderBasicsObjC",
            path: "ThunderBasicsObjC",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "ThunderBasicsTests",
            dependencies: ["ThunderBasics"],
            path: "ThunderBasicsTests"
        )
    ]
)
