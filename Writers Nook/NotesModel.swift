import Combine
import Foundation
import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    var id = UUID()
    var note: String
    var date: Date = Date()
    
    init (_ note: String) {
        self.note = note
    }
}
