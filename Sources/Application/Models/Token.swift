import Foundation
import SwiftKueryORM

struct Token: Codable {
    let id: Int?
    let token: UUID
    let username: String
    let expiry: Date
}

extension Token: Model {}
