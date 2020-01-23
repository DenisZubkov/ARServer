//
//  OAuth2Routes.swift
//  Application
//
//  Created by Denis Bystruev on 09.01.2020.
//

import Credentials
import CredentialsGoogle
import KituraSession
import LoggerAPI

var loggedUser: UserProfile? {
    didSet {
        Log.debug("loggedUser.displayName = \(loggedUser?.displayName ?? "nil")")
    }
}

func initializeOAuth2Routes(app: App) {
    let clientID = "Get your key at console.cloud.google.com"
    let clientSecret = "Get your secret at console.cloud.google.com"
    let callbackUrl = "http://server.getoutfit.ru:8888/oauth2/login"
    let credentials = CredentialsGoogle(clientId: clientID, clientSecret: clientSecret, callbackUrl: callbackUrl)
    
    let credentialsMiddleware = Credentials(options: ["successRedirect": "/oauth2/protected"])
    credentialsMiddleware.register(plugin: credentials)
    
    let session = Session(secret: "AuthSecret", cookie: [CookieParameter.name("ARServer-Auth-cookie")])
    app.router.all("/oauth2", middleware: session)
    
    app.router.get("/oauth2/login", handler: credentialsMiddleware.authenticate(credentialsType: credentials.name))
    
    app.router.get("/oauth2/protected") { request, response, next in
        guard let user = request.userProfile else {
            loggedUser = nil
            return try response.send("You are not authorized").end()
        }
        loggedUser = user
        response.send("Authorized as \(user.displayName)")
        next()
    }
    
    app.router.get("/oauth2/logout") { request, response, next in
        let logoutMessage: String
        
        if let user = loggedUser {
            logoutMessage = "Good bye, \(user.displayName)!"
        } else {
            logoutMessage = "Already logged out"
        }
        credentialsMiddleware.logOut(request: request)
        loggedUser = nil
        response.send(logoutMessage)
        next()
    }
}
