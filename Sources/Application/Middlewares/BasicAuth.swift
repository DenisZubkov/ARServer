//
//  BasicAuth.swift
//  Application
//
//  Created by Denis Bystruev on 26.12.2019.
//

import CredentialsHTTP

public struct BasicAuth: TypeSafeHTTPBasic {
    public static let authenticate = ["user": "password"]
    
    public static func verifyPassword(username: String, password: String, callback: @escaping (BasicAuth?) -> Void) {
        if
            let storedPassword = authenticate[username],
            storedPassword == password
        {
            callback(BasicAuth(id: username))
        } else {
            callback(nil)
        }
    }
    
    public var id: String
}
