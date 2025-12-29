import Foundation

struct Word: Identifiable, Codable, Equatable {
    let id: UUID
    var german: String
    var translation: String
    var partOfSpeech: String
    var isFavorite: Bool

    init(id: UUID = UUID(), german: String, translation: String, partOfSpeech: String = "", isFavorite: Bool = false) {
        self.id = id
        self.german = german
        self.translation = translation
        self.partOfSpeech = partOfSpeech
        self.isFavorite = isFavorite
    }
}
