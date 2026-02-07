import SwiftUI

struct GrammarView: View {
    @EnvironmentObject private var appState: AppState
    @State private var expandedTopicIDs: Set<String> = []

    var body: some View {
        NavigationView {
            List {
                if appState.topicsForSelectedLevel.isEmpty {
                    ContentUnavailableView("Немає тем", systemImage: "text.book.closed", description: Text("Додайте теми у Resources/grammar_topics.json"))
                } else {
                    ForEach(appState.topicsForSelectedLevel) { topic in
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                if expandedTopicIDs.contains(topic.id) {
                                    Text(topic.explanation)
                                    if !topic.examples.isEmpty {
                                        VStack(alignment: .leading, spacing: 4) {
                                            ForEach(topic.examples, id: \.self) { ex in
                                                Text("• \(ex)")
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                            }
                        } header: {
                            HStack {
                                Text(topic.title)
                                    .font(.headline)
                                Spacer()
                                Button(action: { toggle(topic) }) {
                                    Image(systemName: expandedTopicIDs.contains(topic.id) ? "chevron.up" : "chevron.down")
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Граматика")
        }
    }

    private func toggle(_ topic: GrammarTopic) {
        if expandedTopicIDs.contains(topic.id) {
            expandedTopicIDs.remove(topic.id)
        } else {
            expandedTopicIDs.insert(topic.id)
        }
    }
}

#Preview {
    GrammarView().environmentObject(AppState())
}