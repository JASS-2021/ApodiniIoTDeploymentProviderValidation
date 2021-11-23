// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestWebService",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "TestWebService",
            targets: ["TestWebService"])
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/ApodiniIoTDeploymentProvider", .branch("develop")),
        .package(url: "https://github.com/Apodini/Apodini.git", .upToNextMinor(from: "0.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "TestWebService",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniREST", package: "Apodini"),
                .product(name: "ApodiniOpenAPI", package: "Apodini"),
                .product(name: "ApodiniDeploy", package: "Apodini"), 
                .product(name: "DeploymentTargetIoTRuntime", package: "ApodiniIoTDeploymentProvider"),
                .product(name: "LifxIoTDeploymentOption", package: "ApodiniIoTDeploymentProvider"),
                .product(name: "DuckieIoTDeploymentOption", package: "ApodiniIoTDeploymentProvider")
            ]),
        .testTarget(
            name: "TestWebServiceTests",
            dependencies: ["TestWebService"]),
    ]
)
