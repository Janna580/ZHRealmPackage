// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZHRealmPackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZHRealmPackage",
            targets: ["ZHRealmPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/realm/realm-cocoa", from: "10.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ZHRealmPackage",
            dependencies: ["RealmSwift"]),
        .testTarget(
            name: "ZHRealmPackageTests",
            dependencies: ["ZHRealmPackage"]),
    ]
)
