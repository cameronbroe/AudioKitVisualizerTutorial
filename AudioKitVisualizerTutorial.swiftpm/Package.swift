// swift-tools-version: 5.5

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "AudioKit Visualizer",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "AudioKit Visualizer",
            targets: ["AppModule"],
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .microphone(purposeString: "Used to record input to visualize what is recorded")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AudioKit/AudioKit", "5.4.0"..<"6.0.0"),
        .package(url: "https://github.com/AudioKit/AudioKitUI", .exact("0.1.5"))
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "AudioKit", package: "AudioKit"),
                .product(name: "AudioKitUI", package: "AudioKitUI")
            ],
            path: "."
        )
    ]
)
