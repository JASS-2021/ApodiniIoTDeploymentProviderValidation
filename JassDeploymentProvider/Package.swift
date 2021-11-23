// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        )
    ],
    dependencies: [
        .package(name: "ApodiniIoTDeploymentProvider", url: "https://github.com/Apodini/ApodiniIoTDeploymentProvider.git", .branch("develop")),
        .package(name: "swift-device-discovery", url: "https://github.com/Apodini/SwiftDeviceDiscovery.git", .branch("master")),
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
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftDeviceDiscovery", package: "swift-device-discovery")
//                .product(name: "LifxDiscoveryActions", package: "swift-nio-lifx-impl")
            ]
        ),
        .target(
            name: "LifxIoTDeploymentOption",
            dependencies: [
//                .product(name: "ApodiniDeployBuildSupport", package: "Apodini"),
                .product(name: "DeploymentTargetIoTCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckieIoTDeploymentOption",
            dependencies: [
//                .product(name: "ApodiniDeployBuildSupport", package: "Apodini"),
                .product(name: "DeploymentTargetIoTCommon", package: "ApodiniIoTDeploymentProvider")
            ]
        ),
        .target(
            name: "DuckiePostDiscoveryAction",
            dependencies: [
                .product(name: "SwiftDeviceDiscovery", package: "swift-device-discovery")
            ]
        ),
    ]
)
