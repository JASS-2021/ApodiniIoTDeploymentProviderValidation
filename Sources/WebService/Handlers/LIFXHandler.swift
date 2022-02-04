import Apodini
import Foundation


struct LIFXHandler: Handler {
    struct LIFXLamp: Codable, ResponseTransformable {
        let id: UUID
        let name: String
        let brightness: Double
    }
    
    func handle() -> LIFXLamp {
        LIFXLamp(id: UUID(), name: "LIFX Lamp 1", brightness: 100)
    }
}
