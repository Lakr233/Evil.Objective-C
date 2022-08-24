// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EvalObjC",
    products: [
        .library(name: "EvalObjC", targets: ["EvalObjC"]),
    ],
    targets: [
        .target(
            name: "EvalObjC",
            dependencies: []),
        .testTarget(
            name: "EvalObjCTests",
            dependencies: ["EvalObjC"]),
    ]
)
