// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "FormController",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "FormController",
            targets: ["FormController"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FormController",
            dependencies: []),
    ]
)
