import SwiftUI

struct GrammarView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTopic: GrammarTopic?
    @State private var showingTopicDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Level header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Граматика")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Рівень \(userProgress.currentLevel.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Show level selector
                        }) {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress overview
                    let completedTopics = dataManager.getGrammarTopics(for: userProgress.currentLevel).filter { topic in
                        userProgress.completedGrammarTopics.contains(topic.id)
                    }
                    let totalTopics = dataManager.getGrammarTopics(for: userProgress.currentLevel).count
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(completedTopics.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("завершено")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        
                        VStack {
                            Text("\(totalTopics)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("всього тем")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Grammar topics list
                    LazyVStack(spacing: 16) {
                        ForEach(dataManager.getGrammarTopics(for: userProgress.currentLevel)) { topic in
                            GrammarTopicCard(
                                topic: topic,
                                isCompleted: userProgress.completedGrammarTopics.contains(topic.id)
                            ) {
                                selectedTopic = topic
                                showingTopicDetail = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingTopicDetail) {
            if let topic = selectedTopic {
                GrammarTopicDetailView(
                    topic: topic,
                    isCompleted: userProgress.completedGrammarTopics.contains(topic.id)
                ) {
                    userProgress.markGrammarTopicCompleted(topic.id)
                }
            }
        }
    }
}

struct GrammarTopicCard: View {
    let topic: GrammarTopic
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(topic.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                    }
                    
                    Text(topic.explanation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(topic.level.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        Text("\(topic.examples.count) прикладів")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCompleted ? Color.green.opacity(0.05) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCompleted ? Color.green.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GrammarView()
        .environmentObject(UserProgress())
        .environmentObject(DataManager())
}