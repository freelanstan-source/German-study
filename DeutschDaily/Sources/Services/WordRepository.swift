import Foundation

enum WordRepositoryError: Error {
    case resourceNotFound
}

enum WordRepository {
    static func loadAllWords() throws -> [Word] {
        if let url = Bundle.main.url(forResource: "seed_words", withExtension: "json") {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Word].self, from: data)
        }
        // Fallback: try Resources folder in development if running outside app bundle
        let fileManager = FileManager.default
        let possiblePaths = [
            "Resources/seed_words.json",
            "./Resources/seed_words.json",
            "/workspace/DeutschDaily/Resources/seed_words.json"
        ]
        for path in possiblePaths {
            if fileManager.fileExists(atPath: path) {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                return try decoder.decode([Word].self, from: data)
            }
        }
        throw WordRepositoryError.resourceNotFound
    }
}