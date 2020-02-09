import Foundation
import LoggerAPI
import SwiftKuery
import SwiftKueryORM

struct User: Codable {
    var id: Int?
    var username: String
    var password: String
    var salt: String
    var isadmin: Int
}

extension User: Model {
    public static func findAll(username: String, completion: @escaping ([User]?, RequestError?) -> Void) {
        let users: Table
        do {
            users = try User.getTable()
        } catch {
            Log.error(error.localizedDescription)
            completion(nil, .internalServerError)
            return
        }
        let query = Select(from: users).where("username = ?")
        User.executeQuery(query: query, parameters: [username], completion)
    }
    
    public static func findUsername(username: String, completion: @escaping ([User]?, RequestError?) -> Void) {
        let users: Table
        do {
            users = try User.getTable()
        } catch {
            Log.error(error.localizedDescription)
            completion(nil, .internalServerError)
            return
        }
        let query = Select(from: users).where("username = ?")
        User.executeQuery(query: query, parameters: [username], completion)
    }
}
