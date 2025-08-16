import SwiftUI

struct LearnView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationView {
            List {
                if appState.todaysWords.isEmpty {
                    ContentUnavailableView("Немає слів", systemImage: "checkmark.seal", description: Text("Все вивчено на сьогодні"))
                } else {
                    ForEach(appState.todaysWords) { word in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(word.german)
                                    .font(.headline)
                                Text(word.translation)
                                    .foregroundColor(.secondary)
                                if !word.example.isEmpty {
                                    Text("\"\(word.example)\"")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { appState.isWordLearned(word) },
                                set: { isOn in
                                    if isOn { appState.markWordLearned(word) } else { appState.unmarkWordLearned(word) }
                                }
                            ))
                            .labelsHidden()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Слова — сьогодні")
            .toolbar { toolbar }
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker("Рівень", selection: Binding(get: { appState.selectedLevel }, set: { appState.setLevel($0) })) {
                    ForEach(Level.allCases) { level in
                        Text(level.displayName).tag(level)
                    }
                }
                Stepper(value: Binding(get: { appState.wordsPerDay }, set: { appState.setWordsPerDay($0) }), in: 1...30) {
                    Text("Слів на день: \(appState.wordsPerDay)")
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
        }
    }
}

#Preview {
    LearnView().environmentObject(AppState())
}