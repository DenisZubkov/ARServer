//
//  JWTAuthRoutes.swift
//  Application
//
//  Created by Denis Bystruev on 26.12.2019.
//

import Foundation
import Credentials
import CredentialsJWT
import LoggerAPI
import SwiftJWT

func initializeJWTAuthRoutes(app: App) {
    app.router.post("/login/jwt") { request, response, next in
        let credentials = try request.read(as: UserCredentials.self)
        let claims = ClaimsStandardJWT(
            iss: "SwiftBook",
            sub: credentials.username,
            exp: Date(timeIntervalSinceNow: 60 * 60)
        )
        var jwt = JWT(claims: claims)
        let signedJWT = try jwt.sign(using: App.jwtSigner)
        response.send(signedJWT)
        next()
    }
    
    let jwtCredentials = CredentialsJWT<ClaimsStandardJWT>(verifier: App.jwtVerifier)
    let middleware = Credentials()
    middleware.register(plugin: jwtCredentials)
    
    app.router.get("/login/jwt", middleware: middleware)
    app.router.get("/login/jwt") { request, response, next in
        guard let userProfile = request.userProfile else {
            Log.verbose("Failed JWT authentication")
            response.status(.unauthorized)
            try response.end()
            return
        }
        response.send("\(userProfile.id)\n")
        next()
    }
    
}

// MARK: - JWT Authentication
extension App {
    static let jwtSigner = JWTSigner.hs256(key: Data("SecretSwiftBook".utf8))
    static let jwtVerifier = JWTVerifier.hs256(key: Data("SecretSwiftBook".utf8))
}
