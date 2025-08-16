import Foundation

struct GrammarTopic: Codable, Identifiable, Hashable {
    let id: String
    let level: Level
    let title: String
    let explanation: String
    let examples: [String]
}