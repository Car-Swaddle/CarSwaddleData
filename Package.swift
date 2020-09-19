// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CarSwaddleData",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CarSwaddleData",
            targets: ["CarSwaddleData"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Authentication", url: "https://github.com/Car-Swaddle/Authentication", .branch("master")),
        .package(name: "CarSwaddleNetworkRequest", url: "https://github.com/Car-Swaddle/CarSwaddleNetworkRequest", .branch("master")),
        .package(name: "CarSwaddleStore", url: "https://github.com/Car-Swaddle/CarSwaddleStore", .branch("master")),
        .package(name: "Disk", url: "https://github.com/saoudrizwan/Disk.git", .upToNextMajor(from: "0.6.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CarSwaddleData",
            dependencies: ["Authentication", "CarSwaddleNetworkRequest", "CarSwaddleStore", "Disk"]),
        .testTarget(
            name: "CarSwaddleDataTests",
            dependencies: ["CarSwaddleData"]),
    ]
)
