// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSAppCore
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSAppCore",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSAppCore",
            type: .static,
            targets: ["DNSAppCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/DoubleNode/DNSBlankSystems.git", from: "1.11.1"),
        .package(url: "https://github.com/DoubleNode/DNSBlankWorkers.git", from: "1.11.19"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.11.6"),
        .package(url: "https://github.com/DoubleNode/DNSCrashWorkers.git", from: "1.11.17"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "1.11.1"),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", from: "1.11.10"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSAppCore",
            dependencies: [
                "DNSBlankWorkers", "DNSBlankSystems", "DNSCore", "DNSCrashWorkers", "DNSError",
                "DNSProtocols",
        ]),
        .testTarget(
            name: "DNSAppCoreTests",
            dependencies: ["DNSAppCore"],
            resources: [.copy("Constants.plist")]),
    ],
    swiftLanguageVersions: [.v5]
)
