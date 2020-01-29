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
    func basicAuthLogin(user: BasicAuth, respondWith: ([Object]?, RequestError?) -> Void) {
        Log.info("User \(user.id) logged in")
        let objects = [Object(id: 99, userId: 10, url: URL(string: "https://apple.com")!, date: Date())]
        respondWith(objects, nil)
    }
}
