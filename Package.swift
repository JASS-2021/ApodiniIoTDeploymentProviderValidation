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
    name: "JASS2021IoTDeploymentProvider",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "JASS2021IoTDeploymentProvider",
            targets: ["JASS2021IoTDeploymentProvider"]
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
            name: "WebService",
            targets: ["WebService"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/Apodini.git", .branch("develop")),
        .package(url: "https://github.com/Apodini/ApodiniIoTDeploymentProvider.git", .branch("feature/apodiniDeployer")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0"))
    ],
    targets: [
        .executableTarget(
            name: "JASS2021IoTDeploymentProvider",
            dependencies: [
                .product(name: "IoTDeploymentProvider", package: "ApodiniIoTDeploymentProvider"),
                .product(name: "IoTDeploymentProviderCommon", package: "ApodiniIoTDeploymentProvider"),
                .target(name: "LifxIoTDeploymentOption"),
                .target(name: "DuckieIoTDeploymentOption"),
                .target(name: "DuckiePostDiscoveryAction"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "LifxIoTDeploymentOption",
            dependencies: [
                .product(name: "IoTDeploymentProviderCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckieIoTDeploymentOption",
            dependencies: [
                .product(name: "IoTDeploymentProviderCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckiePostDiscoveryAction",
            dependencies: [
                .product(name: "IoTDeploymentProvider", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .executableTarget(
            name: "WebService",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniREST", package: "Apodini"),
                .product(name: "ApodiniOpenAPI", package: "Apodini"),
                .product(name: "ApodiniDeployer", package: "Apodini"),
                .product(name: "IoTDeploymentProviderRuntime", package: "ApodiniIoTDeploymentProvider"),
                .target(name: "LifxIoTDeploymentOption"),
                .target(name: "DuckieIoTDeploymentOption")
            ]
        )
    ]
)
