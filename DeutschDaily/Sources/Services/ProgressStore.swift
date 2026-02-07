import Foundation

final class ProgressStore {
    private let defaults: UserDefaults

    private enum Keys {
        static let selectedLevel = "dd.selectedLevel"
        static let wordsPerDay = "dd.wordsPerDay"
        static let lastPlannedDate = "dd.lastPlannedDate"
        static let todaysWordIDs = "dd.todaysWordIDs"
        static let todaysCompletedIDs = "dd.todaysCompletedIDs"
        static let reviewWordIDsForToday = "dd.reviewWordIDsForToday"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Settings
    func saveSelectedLevel(_ level: Level) {
        defaults.set(level.rawValue, forKey: Keys.selectedLevel)
    }

    func loadSelectedLevel() -> Level? {
        guard let raw = defaults.string(forKey: Keys.selectedLevel) else { return nil }
        return Level(rawValue: raw)
    }

    func saveWordsPerDay(_ value: Int) {
        defaults.set(value, forKey: Keys.wordsPerDay)
    }

    func loadWordsPerDay() -> Int? {
        let value = defaults.integer(forKey: Keys.wordsPerDay)
        return value == 0 ? nil : value
    }

    // MARK: - Planning
    func saveLastPlannedDate(_ date: Date) {
        defaults.set(date, forKey: Keys.lastPlannedDate)
    }

    func loadLastPlannedDate() -> Date? {
        defaults.object(forKey: Keys.lastPlannedDate) as? Date
    }

    func saveTodaysWordIDs(_ ids: [String]) {
        defaults.set(ids, forKey: Keys.todaysWordIDs)
    }

    func loadTodaysWordIDs() -> [String]? {
        defaults.stringArray(forKey: Keys.todaysWordIDs)
    }

    func saveTodaysCompletedIDs(_ ids: [String]) {
        defaults.set(ids, forKey: Keys.todaysCompletedIDs)
    }

    func loadTodaysCompletedIDs() -> Set<String>? {
        let array = defaults.stringArray(forKey: Keys.todaysCompletedIDs)
        if let array { return Set(array) }
        return nil
    }

    func saveReviewWordIDsForToday(_ ids: [String]) {
        defaults.set(ids, forKey: Keys.reviewWordIDsForToday)
    }

    func loadReviewWordIDsForToday() -> [String]? {
        defaults.stringArray(forKey: Keys.reviewWordIDsForToday)
    }

    // MARK: - Reset
    func resetAll() {
        [Keys.selectedLevel,
         Keys.wordsPerDay,
         Keys.lastPlannedDate,
         Keys.todaysWordIDs,
         Keys.todaysCompletedIDs,
         Keys.reviewWordIDsForToday].forEach { defaults.removeObject(forKey: $0) }
    }
}