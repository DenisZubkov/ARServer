//
//  BasicAuth.swift
//  Application
//
//  Created by Denis Bystruev on 26.12.2019.
//

import CredentialsHTTP

public struct BasicAuth: TypeSafeHTTPBasic {
    
    public var id: String
    
    public static func verifyPassword(username: String, password: String, callback: @escaping (BasicAuth?) -> Void) {
        User.findUsername(username: username) { users, error in
            guard let users = users else {
                callback(nil)
                return
            }
            for user in users {
                if user.username == username,
                user.password == password
                {
                    callback(BasicAuth(id: username))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    
}
