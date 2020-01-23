// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARServer",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.9.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Credentials.git", from: "2.5.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-CredentialsGoogle.git", from: "2.3.2"),
        .package(url: "https://github.com/IBM-Swift/Kitura-CredentialsHTTP.git", from: "2.1.3"),
        .package(url: "https://github.com/IBM-Swift/Kitura-CredentialsJWT.git", from: "1.0.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-OpenAPI.git", from: "1.3.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Session.git", from: "3.3.4"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery-ORM.git", from: "0.6.1"),
        .package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", from: "2.0.2"),
    ],
    targets: [
        .target(
            name: "ARServer",
            dependencies: [ .target(name: "Application") ]
        ),
        .target(
            name: "Application",
            dependencies: [
                "Credentials",
                "CredentialsGoogle",
                "CredentialsHTTP",
                "CredentialsJWT",
                "HeliumLogger",
                "Kitura",
                "KituraOpenAPI",
                "KituraSession",
                "SwiftKueryMySQL",
                "SwiftKueryORM",
            ]
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: [ .target(name: "Application") ]
        ),
    ]
)
