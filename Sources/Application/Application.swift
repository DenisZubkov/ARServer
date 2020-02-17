import Kitura
import KituraOpenAPI
import Foundation

public class App {

    let router = Router()
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    public init() throws {

    }

    func postInit() throws {
        //createUSDZDirectory()
        initializeBasicAuthRoutes(app: self)
        initializeJWTAuthRoutes(app: self)
        initializeOAuth2Routes(app: self)
        initializeORMRoutes(app: self)
        initializeSessionRoutes(app: self)
        KituraOpenAPI.addEndpoints(to: router)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8088, with: router)
        Kitura.run()
    }
    
}
