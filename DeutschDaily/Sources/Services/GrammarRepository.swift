import Foundation

enum GrammarRepositoryError: Error {
    case resourceNotFound
}

enum GrammarRepository {
    static func loadAllTopics() throws -> [GrammarTopic] {
        if let url = Bundle.main.url(forResource: "grammar_topics", withExtension: "json") {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([GrammarTopic].self, from: data)
        }
        // Fallback: dev paths
        let fileManager = FileManager.default
        let possiblePaths = [
            "Resources/grammar_topics.json",
            "./Resources/grammar_topics.json",
            "/workspace/DeutschDaily/Resources/grammar_topics.json"
        ]
        for path in possiblePaths {
            if fileManager.fileExists(atPath: path) {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                return try decoder.decode([GrammarTopic].self, from: data)
            }
        }
        throw GrammarRepositoryError.resourceNotFound
    }
}