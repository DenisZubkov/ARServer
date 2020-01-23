import Foundation
import LoggerAPI
import SwiftKuery
import SwiftKueryORM

struct User: Codable {
    let id: Int?
    let username: String
    let password: String
    let salt: String
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
}
