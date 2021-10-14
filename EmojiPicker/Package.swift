// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EmojiPicker",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "EmojiPicker",
            targets: ["EmojiPicker"]
        ),
    ],
    targets: [
        .target(
            name: "EmojiPicker",
            resources: [
                .process("Resources/emojis.json"),
            ]
        ),
    ]
)
