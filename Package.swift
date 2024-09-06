// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorPluginLabelPrinter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorPluginLabelPrinter",
            targets: ["CapacitorPluginLabelPrinterPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "CapacitorPluginLabelPrinterPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorPluginLabelPrinterPlugin"),
        .testTarget(
            name: "CapacitorPluginLabelPrinterPluginTests",
            dependencies: ["CapacitorPluginLabelPrinterPlugin"],
            path: "ios/Tests/CapacitorPluginLabelPrinterPluginTests")
    ]
)