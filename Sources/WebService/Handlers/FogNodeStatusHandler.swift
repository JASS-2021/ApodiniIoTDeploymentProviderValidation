import Apodini
import Foundation


struct FogNodeStatusHandler: Handler {
    struct FogNode: Codable, ResponseTransformable {
        let cpuUsage: Double
        let ramUsage: Double
    }
    
    func handle() -> FogNode {
        FogNode(cpuUsage: 0.42, ramUsage: 42)
    }
}
