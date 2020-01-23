import Application
import LoggerAPI
import HeliumLogger

HeliumLogger.use(.debug)

do {
    let app = try App()
    try app.run()
} catch let error {
    Log.error(error.localizedDescription)
}
