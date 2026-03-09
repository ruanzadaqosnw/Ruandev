// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RuanDevAPIServer",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "RuanDevAPIServer", targets: ["RuanDevAPIServer"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RuanDevAPIServer",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
