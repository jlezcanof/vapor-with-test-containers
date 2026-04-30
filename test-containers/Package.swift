// swift-tools-version: 6.1

import PackageDescription

// Este es el repositorio oficial del que me he descargado esta libreria
// url:"https://github.com/Mongey/swift-test-containers"...revision: "0921a1f653b5f4da41875d800aeec162c5871f27"

//../swift-test-containers
//        .package(url: "https://github.com/Mongey/swift-test-containers", revision: "0921a1f653b5f4da41875d800aeec162c5871f27"),
// Pinned to last revision compatible with swift-test-containers (breaking changes landed 2026-03-13)

let package = Package(
    name: "test-containers",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "TestContainers",
            targets: ["TestContainers"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", revision: "ba5888ad7758cbcbe7abebac37860b1652af2d9c"),// from: "0.3", "branch": "main"
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.21.0"),
    ],
    targets: [
        .target(
            name: "TestContainers",
            dependencies: [
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux, .windows])),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ]
        ),
        .testTarget(
            name: "TestContainersTests",
            dependencies: ["TestContainers"]
        )
    ]
)
