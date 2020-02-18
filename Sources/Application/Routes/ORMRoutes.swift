import KituraContracts
import LoggerAPI
import SwiftKueryORM
import SwiftKueryMySQL
import Foundation

func initializeORMRoutes(app: App) {
    // Initialize MySQL Database
    let pool = MySQLConnection.createPool(
        host: "78.47.113.172",
        user: "aruser",
        password: "arpassword",
        database: "ardb",
        port: 3306,
        poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50)
    )
    Database.default = Database(pool)
    
    // Create tables if they do not exist
    do {
        try User.createTableSync()
        let user = User(id: 0, username: "admin", password: "admin", salt: "", isadmin: 1)
        user.save() { user, requestError in
            if let user = user {
                Log.info("User Created \(user.username)")
            }
        }
        try Object.createTableSync()
        try Token.createTableSync()
        
        Log.info("All tables created")
    } catch {
        Log.error("Failed to create table: \(error)")
    }
    
    // CheckConnect
    app.router.get("/check", handler: app.checkServer)
    
    // Initialize File routes
    app.router.post("/file", handler: app.createFileProtected(user:file:completion:))
    app.router.get("/file", handler: app.findFileProtected(user:filename:completion:))
    app.router.get("/image", handler: app.findImageProtected(user:filename:completion:))
    app.router.get("/Model", handler: app.findModelProtected(user:filename:completion:))
    app.router.delete("/file", handler: app.removeFileProtected(user:filename:completion:))

    // Initialize Object routes
    app.router.post("/object", handler: app.createObjectProtected(user:object:completion:))
    app.router.get("/object", handler: app.findObjectProtected(user:id:completion:))
    app.router.get("/objects/all", handler: app.findObjectsProtected(user:completion:))
    app.router.get("/objects/public", handler: app.findObjectsPublic)
    app.router.get("/objects/user", handler: app.findObjectsForUserProtected(user:userId:completion:))
    app.router.get("/objects/username", handler: app.findObjectsForUserProtected(user:username:completion:))
    app.router.put("/object", handler: app.updateObjectProtected(user:id:object:completion:))
    app.router.delete("/object", handler: app.removeObjectProtected(user:id:completion:))
    
//    // Initiallize Token routes
//    app.router.post("/token", handler: app.createToken)
//    app.router.get("/token", handler: app.findToken)
//    app.router.get("/tokens/all", handler: app.findTokens)
//    app.router.put("/token", handler: app.updateToken)
//    app.router.delete("/token", handler: app.removeToken)
    
    // Initiallize User routes
    app.router.post("/user", handler: app.createUserProtected(user:userCreate:completion:))
    app.router.get("/user", handler: app.findUserProtected(user:id:completion:))
    app.router.get("/users/all", handler: app.findUsersProtected(user:completion:))
    app.router.put("/user", handler: app.updateUserProtected(id:user:completion:))
    app.router.delete("/user", handler: app.removeUserProtected(user:id:completion:))
}

//MARK: Check Server Route

extension App {
    func checkServer(respondWith: ([User]?, RequestError?) -> Void) {
        Log.info("Server cheked")
        let users = [User(id: 0, username: "admin", password: "admin", salt: "", isadmin: 1)]
        respondWith(users, nil)
    }
}


// MARK: - File Routes
extension App {
    
    
    // MARK: - File, Image, Model Routes
    
    
    func createFileProtected(user: BasicAuth, file: ObjectFile, completion: @escaping (ObjectFile?, RequestError?) -> Void) {
        guard let filename = file.filename else {
            completion(nil, .noContent)
            return
        }
        
        let fileURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("usdz")
        print(fileURL.absoluteString)
        do {
            try file.fileData?.write(to: fileURL)
        } catch {
            completion(nil, .badRequest)
        }
        let thumbnailURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("png")
        print(thumbnailURL.absoluteString)
        do {
            try file.thumbnailData?.write(to: thumbnailURL)
        } catch {
            completion(nil, .badRequest)
        }
        completion(file, nil)
    }
    
    
    
    func findFileProtected(user: BasicAuth, filename: String, completion: @escaping (ObjectFile?, RequestError?) -> Void) {
        
        var objectFile = ObjectFile()
        objectFile.filename = filename
        let fileURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("usdz")
        do {
            try objectFile.fileData = Data.init(contentsOf: fileURL)
        } catch {
            completion(nil, .notFound)
        }
        let thumbnailURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("png")
        do {
            try objectFile.thumbnailData = Data.init(contentsOf: thumbnailURL)
        } catch {
            completion(nil, .notFound)
        }
        completion(objectFile, nil)
    }
    
    func findImageProtected(user: BasicAuth, filename: String, completion: @escaping (ObjectFile?, RequestError?) -> Void) {
        
        var objectFile = ObjectFile()
        objectFile.filename = filename
        let thumbnailURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("png")
        do {
            try objectFile.thumbnailData = Data.init(contentsOf: thumbnailURL)
        } catch {
            completion(nil, .notFound)
        }
        completion(objectFile, nil)
    }
    
    func findModelProtected(user: BasicAuth, filename: String, completion: @escaping (ObjectFile?, RequestError?) -> Void) {
        
        var objectFile = ObjectFile()
        objectFile.filename = filename
        let fileURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("usdz")
        do {
            try objectFile.fileData = Data.init(contentsOf: fileURL)
        } catch {
            completion(nil, .notFound)
        }
        completion(objectFile, nil)
    }
    
    
    func removeFileProtected(user: BasicAuth, filename: String, completion: @escaping (RequestError?) -> Void) {
        var objectFile = ObjectFile()
        objectFile.filename = filename
        let fileURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("usdz")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("Can't remove file \(filename).uszd")
            }
        } else {
             print("Can't remove file \(filename).uszd")
        }
        let thumbnailURL = self.baseURL.appendingPathComponent("usdz").appendingPathComponent(filename).appendingPathExtension("png")
        if FileManager.default.fileExists(atPath: thumbnailURL.path) {
            do {
                try FileManager.default.removeItem(atPath: thumbnailURL.path)
            } catch {
                print("Can't remove file \(filename).png")
            }
        } else {
            print("Can't remove file \(filename).png")
        }
        completion(.ok)
    }

}


// MARK: - Object Routes

extension App {
    func createObjectProtected(user: BasicAuth, object: Object, completion: @escaping (Object?, RequestError?) -> Void) {
        
        object.save(completion)
    }
    
    func findObjectProtected(user: BasicAuth, id: Int, completion: @escaping (Object?, RequestError?) -> Void) {
        Object.find(id: id, completion)
    }
    
    
    
    func findObjectsProtected(user: BasicAuth, completion: @escaping ([Object]?, RequestError?) -> Void) {
        //Object.findAll(completion)
        Object.findAll(using: Database.default, completion)
    }
    
    func findObjectsForUserProtected(user: BasicAuth, userId: Int, completion: @escaping ([Object]?, RequestError?) -> Void) {
        Object.findAllForUser(id: userId, completion: completion)
    }
    
    func findObjectsForUserProtected(user: BasicAuth, username: String, completion: @escaping ([Object]?, RequestError?) -> Void) {
        Object.findAllForUser(name: username, completion: completion)
    }
    
    func findObjectsPublic(completion: @escaping ([Object]?, RequestError?) -> Void) {
        Object.findAllPublic(completion: completion)
    }
    
    func removeObjectProtected(user: BasicAuth, id: Int, completion: @escaping (RequestError?) -> Void) {
        Object.delete(id: id, completion)
    }
    
    func updateObjectProtected(user: BasicAuth, id: Int, object: Object, completion: @escaping (Object?, RequestError?) -> Void) {
        guard let objectId = object.id, id == objectId else {
            completion(nil, .notFound)
            return
        }
        object.update(id: id, completion)
    }
}

// MARK: - Token Routes
//extension App {
//    func createToken(token: Token, completion: @escaping (Token?, RequestError?) -> Void) {
//        token.save(completion)
//    }
//
//    func findToken(id: Int, completion: @escaping (Token?, RequestError?) -> Void) {
//        Token.find(id: id, completion)
//    }
//
//    func findTokens(completion: @escaping ([Token]?, RequestError?) -> Void) {
//        Token.findAll(completion)
//    }
//
//    func removeToken(id: Int, completion: @escaping (RequestError?) -> Void) {
//        Token.delete(id: id, completion)
//    }
//
//    func updateToken(id: Int, token: Token, completion: @escaping (Token?, RequestError?) -> Void) {
//        guard let tokenId = token.id, tokenId == id else {
//            completion(nil, .notFound)
//            return
//        }
//        token.update(id: id, completion)
//    }
//}

// MARK: - User Routes
extension App {
    func createUserProtected(user: BasicAuth, userCreate: User, completion: @escaping (User?, RequestError?) -> Void) {
        userCreate.save(completion)
    }
    
    func findUserProtected(user: BasicAuth, id: Int, completion: @escaping (User?, RequestError?) -> Void) {
        User.find(id: id, completion)
    }
    
    func findUsernameProtected(user: BasicAuth, username: String, completion: @escaping ([User]?, RequestError?) -> Void) {
        User.findUsername(username: username, completion: completion)
    }
    
    func findUsersProtected(user: BasicAuth, completion: @escaping ([User]?, RequestError?) -> Void) {
        User.findAll(completion)
    }
    
    func removeUserProtected(user: BasicAuth, id: Int, completion: @escaping (RequestError?) -> Void) {
        if id != 0  {
            User.delete(id: id, completion)
        } else {
            completion(.badRequest)
        }
    }
    
    func updateUserProtected(id: Int, user: User, completion: @escaping (User?, RequestError?) -> Void) {
        guard let userId = user.id, userId == id else {
            completion(nil, .notFound)
            return
        }
        user.update(id: id, completion)
    }
}
