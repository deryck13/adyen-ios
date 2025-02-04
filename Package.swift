// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Adyen",
    defaultLocalization: "en-us",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Adyen",
            targets: ["Adyen"]
        ),
        .library(
            name: "AdyenEncryption",
            targets: ["AdyenEncryption"]
        ),
        .library(
            name: "AdyenActions",
            targets: ["AdyenActions"]
        ),
        .library(
            name: "AdyenCard",
            targets: ["AdyenCard"]
        ),
        .library(
            name: "AdyenComponents",
            targets: ["AdyenComponents"]
        ),
        .library(
            name: "AdyenDropIn",
            targets: ["AdyenDropIn"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Adyen/adyen-networking-ios",
            exact: Version(2, 0, 0)
        )
    ],
    targets: [
        .binaryTarget(
            name: "Adyen3DS2",
            path: "Adyen3DS2/Static/Adyen3DS2.xcframework"
        ),
        .target(
            name: "Adyen",
            dependencies: [
                .product(name: "AdyenNetworking", package: "adyen-networking-ios")
            ],
            path: "Adyen",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenEncryption",
            dependencies: [
                .target(name: "Adyen")
            ],
            path: "AdyenEncryption",
            exclude: [
                "Info.plist"
            ]
        ),
        .target(
            name: "AdyenActions",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "Adyen3DS2")
            ],
            path: "AdyenActions",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenCard",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "AdyenEncryption")
            ],
            path: "AdyenCard",
            exclude: [
                "Info.plist",
                "Utilities/Non SPM Bundle Extension" // This is to exclude `BundleExtension.swift` file, since swift packages has different code to access internal resources.
            ]
        ),
        .target(
            name: "AdyenComponents",
            dependencies: [
                .target(name: "Adyen"),
                .target(name: "AdyenEncryption")
            ],
            path: "AdyenComponents",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "AdyenDropIn",
            dependencies: [
                .target(name: "AdyenCard"),
                .target(name: "AdyenComponents"),
                .target(name: "AdyenActions")
            ],
            path: "AdyenDropIn",
            exclude: ["Info.plist"]
        )
    ]
)
