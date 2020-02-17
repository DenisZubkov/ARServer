import Kitura
import KituraOpenAPI
import Foundation

public class App {

    let router = Router()
    let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    public init() throws {

    }

    func postInit() throws {
        createUSDZDirectory()
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
    
    
    func createUSDZDirectory() {
        if !FileManager.default.fileExists(atPath: baseURL.path) {
            let urlDocuments = FileManager.default.urls(for: .userDirectory, in: .userDomainMask)[0].appendingPathComponent("Documents")
            do {
                try FileManager.default.createDirectory(atPath: urlDocuments.path, withIntermediateDirectories: false, attributes: nil)
                let urlUSDZ = urlDocuments.appendingPathComponent("usdz")
                do {
                    try FileManager.default.createDirectory(atPath: urlUSDZ.path, withIntermediateDirectories: false, attributes: nil)
                }
                catch {
                    print("Error creating usdz folder: \(error)")
                }
            }
            catch {
                print("Error creating Documents folder: \(error)")
            }
        }
        if !FileManager.default.fileExists(atPath: baseURL.appendingPathComponent("usdz").path) {
            let urlUSDZ = baseURL.appendingPathComponent("usdz")
            do {
                try FileManager.default.createDirectory(atPath: urlUSDZ.path, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("Error creating usdz folder: \(error)")
            }
        }
    }
}
