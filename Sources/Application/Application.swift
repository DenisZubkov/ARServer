import Kitura
import KituraOpenAPI

public class App {

    let router = Router()

    public init() throws {

    }

    func postInit() throws {
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
