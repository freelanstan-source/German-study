import Foundation

// MARK: - Language Levels
enum LanguageLevel: String, CaseIterable, Identifiable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .a1: return "Початковий рівень"
        case .a2: return "Базовий рівень"
        case .b1: return "Середній рівень"
        case .b2: return "Вище середнього"
        case .c1: return "Просунутий рівень"
        case .c2: return "Вільне володіння"
        }
    }
    
    var color: String {
        switch self {
        case .a1: return "green"
        case .a2: return "blue"
        case .b1: return "orange"
        case .b2: return "purple"
        case .c1: return "red"
        case .c2: return "black"
        }
    }
}

// MARK: - Grammar Topic
struct GrammarTopic: Identifiable {
    let id = UUID()
    let title: String
    let explanation: String
    let examples: [String]
    let level: LanguageLevel
    let isCompleted: Bool
    
    init(title: String, explanation: String, examples: [String], level: LanguageLevel, isCompleted: Bool = false) {
        self.title = title
        self.explanation = explanation
        self.examples = examples
        self.level = level
        self.isCompleted = isCompleted
    }
}

// MARK: - Vocabulary Word
struct VocabularyWord: Identifiable, Codable {
    let id = UUID()
    let german: String
    let ukrainian: String
    let english: String
    let level: LanguageLevel
    let partOfSpeech: String
    let example: String
    var isLearned: Bool
    var lastReviewed: Date?
    var reviewCount: Int
    
    init(german: String, ukrainian: String, english: String, level: LanguageLevel, partOfSpeech: String, example: String) {
        self.german = german
        self.ukrainian = ukrainian
        self.english = english
        self.level = level
        self.partOfSpeech = partOfSpeech
        self.example = example
        self.isLearned = false
        self.lastReviewed = nil
        self.reviewCount = 0
    }
}

// MARK: - Daily Progress
struct DailyProgress: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let wordsLearned: Int
    let grammarTopicsCompleted: Int
    let totalStudyTime: TimeInterval
    let level: LanguageLevel
}

// MARK: - User Progress
class UserProgress: ObservableObject, Codable {
    @Published var currentLevel: LanguageLevel = .a1
    @Published var completedGrammarTopics: Set<UUID> = []
    @Published var learnedWords: Set<UUID> = []
    @Published var dailyProgress: [DailyProgress] = []
    @Published var streakDays: Int = 0
    @Published var lastStudyDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case currentLevel, completedGrammarTopics, learnedWords, dailyProgress, streakDays, lastStudyDate
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentLevel = try container.decode(LanguageLevel.self, forKey: .currentLevel)
        completedGrammarTopics = try container.decode(Set<UUID>.self, forKey: .completedGrammarTopics)
        learnedWords = try container.decode(Set<UUID>.self, forKey: .learnedWords)
        dailyProgress = try container.decode([DailyProgress].self, forKey: .dailyProgress)
        streakDays = try container.decode(Int.self, forKey: .streakDays)
        lastStudyDate = try container.decode(Date?.self, forKey: .lastStudyDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentLevel, forKey: .currentLevel)
        try container.encode(completedGrammarTopics, forKey: .completedGrammarTopics)
        try container.encode(learnedWords, forKey: .learnedWords)
        try container.encode(dailyProgress, forKey: .dailyProgress)
        try container.encode(streakDays, forKey: .streakDays)
        try container.encode(lastStudyDate, forKey: .lastStudyDate)
    }
    
    func markGrammarTopicCompleted(_ topicId: UUID) {
        completedGrammarTopics.insert(topicId)
        updateStreak()
    }
    
    func markWordLearned(_ wordId: UUID) {
        learnedWords.insert(wordId)
        updateStreak()
    }
    
    func updateStreak() {
        let today = Date()
        if let lastDate = lastStudyDate {
            let calendar = Calendar.current
            if calendar.isDate(today, inSameDayAs: lastDate) {
                // Same day, no change
            } else if calendar.isDate(today, equalTo: calendar.date(byAdding: .day, value: 1, to: lastDate)!, toGranularity: .day) {
                // Next day, increment streak
                streakDays += 1
            } else {
                // Gap in days, reset streak
                streakDays = 1
            }
        } else {
            streakDays = 1
        }
        lastStudyDate = today
    }
}