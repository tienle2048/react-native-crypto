// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "react-native-awesome-library",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "react-native-awesome-library",
            targets: ["react-native-awesome-library"]
        ),
    ],
    dependencies: [
        .package(url: "git@github.com:bitmark-inc/bip39-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/trustwallet/wallet-core", .branchItem("master")),
        .Package(url: "https://github.com/bitmark-inc/tweetnacl-swiftwrap.git", majorVersion: 1),
        .package(url: "https://github.com/p2p-org/Ed25519HDKeySwift.git", .branchItem("master"))
        // .package(url: "https://github.com/essentiaone/HDWallet.git", .branchItem("master")),
        // .Package(url: "https://github.com/horizontalsystems/hd-wallet-kit-ios.git", .branchItem("master")),
        // .package(name: "HdWalletKit", url: "https://github.com/horizontalsystems/HdWalletKit.Swift.git", .upToNextMajor(from: "1.0.0"))
        // .Package(url: "https://github.com/Sjors/libwally-swift.git", .branchItem("master")),
    ],
    
)
