import Apodini
import Foundation


struct DuckieBotHandler: Handler {
    struct DuckieBot: Codable, ResponseTransformable {
        struct Coordinate: Codable {
            let latitude: Double
            let longitude: Double
        }
        
        let id: UUID
        let name: String
        let location: Coordinate
    }
    
    func handle() -> DuckieBot {
        DuckieBot(id: UUID(), name: "DuckieBot", location: DuckieBot.Coordinate(latitude: 42, longitude: -42))
    }
}
