//
//  BasicAuthRoutes.swift
//  Application
//
//  Created by Denis Bystruev on 26.12.2019.
//

import Foundation
import KituraContracts
import LoggerAPI

func initializeBasicAuthRoutes(app: App) {
    app.router.get("/login/basic", handler: app.basicAuthLogin)
}

// MARK: - Basic Authentication
extension App {
    func basicAuthLogin(user: BasicAuth, respondWith: ([User]?, RequestError?) -> Void) {
        Log.info("User \(user.id) logged in")
        let users = [User(id: 0, username: "admin", password: "admin", salt: "", isadmin: 1)]
        respondWith(users, nil)
    }
}
