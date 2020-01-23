//
//  SessionRoutes.swift
//  ARServer
//
//  Created by Denis Bystruev on 26.12.2019.
//

import Kitura
import KituraContracts

func initializeSessionRoutes(app: App) {
    app.router.get("/session", handler: app.getSessionHandler)
    app.router.post("/session", handler: app.postSessionHandler)
}

// MARK: - Session Routes
extension App {
    func getSessionHandler(session: ARServerSession, completion: @escaping ([Object]?, RequestError?) -> Void) {
        completion(session.objects, nil)
    }
    
    func postSessionHandler(session: ARServerSession, object: Object, completion: @escaping (Object?, RequestError?) -> Void) {
        session.objects.append(object)
        session.save()
        completion(object, nil)
    }
}
