// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ThunderBasics",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ThunderBasics",
            targets: ["ThunderBasics"]
        )
    ],
    targets: [
        .target(
            name: "ThunderBasicsObjC",
            path: "Sources/ThunderBasicsObjC",
            publicHeadersPath: "include"
        ),
        .target(
            name: "ThunderBasics",
            dependencies: ["ThunderBasicsObjC"],
            path: "Sources/ThunderBasics",
            resources: [
                .copy("Locale Language Codes/iso639_2.bundle")
            ]
        ),
        .testTarget(
            name: "ThunderBasicsTests",
            dependencies: ["ThunderBasics"],
            path: "Tests/ThunderBasicsTests",
            resources: [
                .copy("3scLogo.png"),
                .copy("arcLogo.jpg"),
                .copy("camrote.png"),
                .copy("colouredBg.png"),
                .copy("flowers.jpg"),
                .copy("jacksonPollock.jpg"),
                .copy("mit.png"),
                .copy("nebraska.jpg"),
                .copy("nonEdgePrimary.png"),
                .copy("nyt.jpg"),
                .copy("vincent.jpg")
            ]
        )
    ]
)
