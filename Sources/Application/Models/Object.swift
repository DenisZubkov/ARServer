import Foundation
import LoggerAPI
import SwiftKuery
import SwiftKueryORM

struct Object: Codable {
    let id: Int?
    let userId: Int
    let url: URL
    let date: Date
}

extension Object: Model {
    public static func findAllForUser(id: Int, completion: @escaping ([Object]?, RequestError?) -> Void) {
        let objects: Table
        do {
            objects = try Object.getTable()
        } catch {
            Log.error(error.localizedDescription)
            completion(nil, .internalServerError)
            return
        }
        let query = Select(from: objects).where("userId = ?")
        Object.executeQuery(query: query, parameters: [id], completion)
    }
    
    public static func findAllForUser(name: String, completion: @escaping ([Object]?, RequestError?) -> Void) {
        let objects: Table
        do {
            objects = try Object.getTable()
        } catch {
            Log.error(error.localizedDescription)
            completion(nil, .internalServerError)
            return
        }
        User.findAll(username: name) { users, error in
            guard let users = users else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, .notFound)
                }
                return
            }
            let userIds = users.compactMap { $0.id }
            guard !userIds.isEmpty else {
                completion(nil, .notFound)
                return
            }
            let suffixCount = userIds.count - 1
            let searchString = "userId = ?" + String(repeating: " or userId = ?", count: suffixCount)
            let query = Select(from: objects).where(searchString)
            Object.executeQuery(query: query, parameters: userIds, completion)
        }
    }
}
