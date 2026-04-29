// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "VaporWithTestContainers",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),// 2.60.0
        // 🧪 Test Containers
            .package(path: "../swift-test-containers")
//        .package(url: "https://github.com/Mongey/swift-test-containers", revision: "0921a1f653b5f4da41875d800aeec162c5871f27"),
        // Pinned to last revision compatible with swift-test-containers (breaking changes landed 2026-03-13)
//        .package(url: "https://github.com/swiftlang/swift-subprocess.git", revision: "ba5888ad7758cbcbe7abebac37860b1652af2d9c"),
    ],
    targets: [
        .executableTarget(
            name: "VaporWithTestContainers",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "VaporWithTestContainersTests",
            dependencies: [
                .target(name: "VaporWithTestContainers"),
                .product(name: "VaporTesting", package: "vapor"),
                .product(name: "TestContainers", package: "swift-test-containers"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
