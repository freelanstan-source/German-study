import SwiftUI

struct ReviewItem: Identifiable, Hashable {
    let id: String
    let question: String
    let correctAnswer: String
    let options: [String]
}

struct ReviewView: View {
    @EnvironmentObject private var appState: AppState
    @State private var items: [ReviewItem] = []
    @State private var currentIndex: Int = 0
    @State private var selectedOption: String? = nil
    @State private var isFinished: Bool = false
    @State private var score: Int = 0

    var body: some View {
        NavigationView {
            Group {
                if isFinished || items.isEmpty {
                    VStack(spacing: 16) {
                        if items.isEmpty {
                            ContentUnavailableView("Немає перевірки", systemImage: "text.badge.checkmark", description: Text("Завтра перевіримо сьогоднішні слова"))
                        } else {
                            Text("Результат: \(score)/\(items.count)")
                                .font(.headline)
                            Button("Почати знову") {
                                start()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                } else {
                    let item = items[currentIndex]
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Перевірка: \(currentIndex + 1) з \(items.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(item.question)
                            .font(.title3)
                        VStack(spacing: 10) {
                            ForEach(item.options, id: \.self) { option in
                                Button(action: { select(option: option) }) {
                                    HStack {
                                        Text(option)
                                        Spacer()
                                        if selectedOption == option {
                                            Image(systemName: option == item.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .foregroundColor(option == item.correctAnswer ? .green : .red)
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)
                            }
                        }
                        Spacer()
                        Button("Далі") {
                            next()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedOption == nil)
                    }
                    .padding()
                }
            }
            .navigationTitle("Перевірка")
            .onAppear { start() }
        }
    }

    private func start() {
        let words = appState.reviewWordsForToday
        guard !words.isEmpty else {
            items = []
            isFinished = true
            score = 0
            return
        }
        var reviewItems: [ReviewItem] = []
        let translations = words.map { $0.translation }
        for word in words.shuffled() {
            let incorrect = translations.shuffled().filter { $0 != word.translation }.prefix(3)
            let options = ([word.translation] + incorrect).shuffled()
            reviewItems.append(ReviewItem(id: word.id, question: word.german, correctAnswer: word.translation, options: options))
        }
        self.items = reviewItems
        self.currentIndex = 0
        self.selectedOption = nil
        self.isFinished = false
        self.score = 0
    }

    private func select(option: String) {
        guard !isFinished else { return }
        selectedOption = option
        if let item = items[safe: currentIndex], option == item.correctAnswer {
            score += 1
        }
    }

    private func next() {
        guard selectedOption != nil else { return }
        if currentIndex + 1 < items.count {
            currentIndex += 1
            selectedOption = nil
        } else {
            isFinished = true
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}