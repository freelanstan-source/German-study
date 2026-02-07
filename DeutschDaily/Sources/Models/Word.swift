import Foundation

struct Word: Codable, Identifiable, Hashable {
    let id: String
    let german: String
    let translation: String
    let partOfSpeech: String
    let example: String
    let level: Level
    let tags: [String]?
}