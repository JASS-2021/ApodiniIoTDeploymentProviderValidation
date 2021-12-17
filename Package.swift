// swift-tools-version:5.5

//
// This source file is part of the JASS open source project
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import PackageDescription

let package = Package(
    name: "JassDeploymentProvider",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "LifxDuckieIoTDeploymentTarget",
            targets: ["LifxDuckieIoTDeploymentTarget"]
        ),
        .library(
            name: "LifxIoTDeploymentOption",
            targets: ["LifxIoTDeploymentOption"]
        ),
        .library(
            name: "DuckieIoTDeploymentOption",
            targets: ["DuckieIoTDeploymentOption"]
        ),
        .executable(
            name: "DemoWebService",
            targets: ["WebService"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/Apodini.git", .upToNextMinor(from: "0.6.1")),
        .package(name: "ApodiniIoTDeploymentProvider", url: "https://github.com/Apodini/ApodiniIoTDeploymentProvider.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0"))
    ],
    targets: [
        .executableTarget(
            name: "LifxDuckieIoTDeploymentTarget",
            dependencies: [
                .product(name: "DeploymentTargetIoT", package: "ApodiniIoTDeploymentProvider"),
                .product(name: "DeploymentTargetIoTCommon", package: "ApodiniIoTDeploymentProvider"),
                .target(name: "LifxIoTDeploymentOption"),
                .target(name: "DuckieIoTDeploymentOption"),
                .target(name: "DuckiePostDiscoveryAction"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "LifxIoTDeploymentOption",
            dependencies: [
                .product(name: "DeploymentTargetIoTCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckieIoTDeploymentOption",
            dependencies: [
                .product(name: "DeploymentTargetIoTCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckiePostDiscoveryAction",
            dependencies: [
                .product(name: "DeploymentTargetIoT", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .executableTarget(
            name: "WebService",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniREST", package: "Apodini"),
                .product(name: "ApodiniOpenAPI", package: "Apodini"),
                .product(name: "ApodiniDeploy", package: "Apodini"),
                .product(name: "DeploymentTargetIoTRuntime", package: "ApodiniIoTDeploymentProvider"),
                .target(name: "LifxIoTDeploymentOption"),
                .target(name: "DuckieIoTDeploymentOption")
            ]
        )
    ]
)
