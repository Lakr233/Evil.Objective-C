// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EvilObjC",
    products: [
        .library(name: "EvilObjC", targets: ["EvilObjC"]),
    ],
    targets: [
        .target(
            name: "EvilObjC",
            dependencies: []),
        .testTarget(
            name: "EvilObjCTests",
            dependencies: ["EvilObjC"]),
    ]
)
