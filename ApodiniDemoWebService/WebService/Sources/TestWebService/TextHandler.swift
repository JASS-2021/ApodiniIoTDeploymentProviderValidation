import Apodini
import Foundation

struct TextHandler: Handler {
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func handle() -> String {
        text
    }
}
