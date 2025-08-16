import Foundation
import SwiftUI

final class AppState: ObservableObject {
    // MARK: - Published UI State
    @Published var selectedLevel: Level
    @Published var wordsPerDay: Int

    @Published private(set) var todaysWords: [Word] = []
    @Published private(set) var todaysCompletedWordIDs: Set<String> = []
    @Published private(set) var reviewWordsForToday: [Word] = []

    @Published private(set) var allWords: [Word] = []
    @Published private(set) var allGrammarTopics: [GrammarTopic] = []

    // MARK: - Private State
    private var idToWord: [String: Word] = [:]
    private var progressStore: ProgressStore
    private var notificationScheduler: NotificationScheduler

    private var lastPlannedDate: Date?
    private var todaysWordIDs: [String] = []
    private var reviewWordIDsForToday: [String] = []

    // MARK: - Init
    init(progressStore: ProgressStore = ProgressStore(),
         notificationScheduler: NotificationScheduler = NotificationScheduler()) {
        self.progressStore = progressStore
        self.notificationScheduler = notificationScheduler

        // Load persisted settings with defaults
        self.selectedLevel = progressStore.loadSelectedLevel() ?? .A1
        self.wordsPerDay = progressStore.loadWordsPerDay() ?? 7

        self.lastPlannedDate = progressStore.loadLastPlannedDate()
        self.todaysWordIDs = progressStore.loadTodaysWordIDs() ?? []
        self.todaysCompletedWordIDs = progressStore.loadTodaysCompletedIDs() ?? []
        self.reviewWordIDsForToday = progressStore.loadReviewWordIDsForToday() ?? []

        loadData()
        rebuildDerivedState()
    }

    // MARK: - Lifecycle
    func onAppLaunch() {
        notificationScheduler.requestAuthorizationIfNeeded()
        refreshForCurrentDayIfNeeded()
    }

    // MARK: - Data Loading
    private func loadData() {
        self.allWords = (try? WordRepository.loadAllWords()) ?? []
        self.allGrammarTopics = (try? GrammarRepository.loadAllTopics()) ?? []
        self.idToWord = Dictionary(uniqueKeysWithValues: allWords.map { ($0.id, $0) })
    }

    private func rebuildDerivedState() {
        self.todaysWords = todaysWordIDs.compactMap { idToWord[$0] }
        self.reviewWordsForToday = reviewWordIDsForToday.compactMap { idToWord[$0] }
    }

    // MARK: - Daily Planning
    func refreshForCurrentDayIfNeeded(currentDate: Date = Date()) {
        guard let last = lastPlannedDate else {
            // First run: make plan for today, review is empty
            planFor(date: currentDate)
            return
        }
        let calendar = Calendar.current
        if !calendar.isDate(last, inSameDayAs: currentDate) {
            rolloverDay(from: last, to: currentDate)
        } else {
            // Ensure derived state matches persisted ids
            rebuildDerivedState()
        }
    }

    private func rolloverDay(from previousDate: Date, to newDate: Date) {
        // Words completed yesterday become today's review (random order)
        let yesterdayCompleted = Array(todaysCompletedWordIDs)
        self.reviewWordIDsForToday = yesterdayCompleted.shuffled()
        progressStore.saveReviewWordIDsForToday(reviewWordIDsForToday)

        // New plan for today
        planFor(date: newDate)
    }

    private func planFor(date: Date) {
        self.lastPlannedDate = date
        progressStore.saveLastPlannedDate(date)

        // Reset today's completion
        self.todaysCompletedWordIDs = []
        progressStore.saveTodaysCompletedIDs([])

        // Select today's words based on selected level
        let candidates = allWords.filter { $0.level == selectedLevel }
        let count = max(1, min(wordsPerDay, candidates.count))
        self.todaysWordIDs = Array(candidates.shuffled().prefix(count)).map { $0.id }
        progressStore.saveTodaysWordIDs(todaysWordIDs)

        // Note: reviewWordIDsForToday already set in rollover; on first plan it stays as is

        rebuildDerivedState()
    }

    // MARK: - Actions
    func markWordLearned(_ word: Word) {
        todaysCompletedWordIDs.insert(word.id)
        progressStore.saveTodaysCompletedIDs(Array(todaysCompletedWordIDs))
        objectWillChange.send()
    }

    func unmarkWordLearned(_ word: Word) {
        todaysCompletedWordIDs.remove(word.id)
        progressStore.saveTodaysCompletedIDs(Array(todaysCompletedWordIDs))
        objectWillChange.send()
    }

    func isWordLearned(_ word: Word) -> Bool {
        todaysCompletedWordIDs.contains(word.id)
    }

    func setLevel(_ level: Level) {
        guard selectedLevel != level else { return }
        selectedLevel = level
        progressStore.saveSelectedLevel(level)
        // Re-plan for today with new level to reflect user's choice
        planFor(date: Date())
    }

    func setWordsPerDay(_ value: Int) {
        let clamped = max(1, min(30, value))
        guard wordsPerDay != clamped else { return }
        wordsPerDay = clamped
        progressStore.saveWordsPerDay(clamped)
        planFor(date: Date())
    }

    func resetProgress() {
        progressStore.resetAll()
        // Reset in-memory as well
        self.lastPlannedDate = nil
        self.todaysWordIDs = []
        self.todaysCompletedWordIDs = []
        self.reviewWordIDsForToday = []
        rebuildDerivedState()
        // Immediately plan for today again
        refreshForCurrentDayIfNeeded()
    }

    // MARK: - Selectors
    var topicsForSelectedLevel: [GrammarTopic] {
        allGrammarTopics.filter { $0.level == selectedLevel }
    }
}