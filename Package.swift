// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUINavigation",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SUINavigation",
            targets: ["SUINavigation"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SUINavigation",
            dependencies: [],
            path: "Sources/SUINavigation"
        ),
//        .testTarget(
//            name: "SUINavigationTests",
//            dependencies: ["SUINavigationCore"])
    ]
)
