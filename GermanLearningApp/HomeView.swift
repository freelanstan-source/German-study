import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var dataManager: DataManager
    @State private var showingLevelSelector = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with current level
                    VStack(spacing: 12) {
                        Text("Німецька мова")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            showingLevelSelector = true
                        }) {
                            HStack {
                                Text("Поточний рівень:")
                                    .foregroundColor(.secondary)
                                Text(userProgress.currentLevel.rawValue)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                        }
                        
                        Text(userProgress.currentLevel.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Streak and progress
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(userProgress.streakDays)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("днів поспіль")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        
                        VStack {
                            Text("\(userProgress.learnedWords.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("слів вивчено")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Quick actions
                    VStack(spacing: 16) {
                        Text("Швидкі дії")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            NavigationLink(destination: DailyStudyView()) {
                                QuickActionCard(
                                    title: "Щоденне вивчення",
                                    subtitle: "5 нових слів",
                                    icon: "calendar.badge.plus",
                                    color: .blue
                                )
                            }
                            
                            NavigationLink(destination: GrammarView()) {
                                QuickActionCard(
                                    title: "Граматика",
                                    subtitle: "\(dataManager.getGrammarTopics(for: userProgress.currentLevel).count) тем",
                                    icon: "book.fill",
                                    color: .purple
                                )
                            }
                            
                            NavigationLink(destination: VocabularyView()) {
                                QuickActionCard(
                                    title: "Словник",
                                    subtitle: "\(dataManager.getVocabularyWords(for: userProgress.currentLevel).count) слів",
                                    icon: "textformat.abc",
                                    color: .green
                                )
                            }
                            
                            NavigationLink(destination: ProgressView()) {
                                QuickActionCard(
                                    title: "Прогрес",
                                    subtitle: "Статистика",
                                    icon: "chart.bar.fill",
                                    color: .orange
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Today's words preview
                    if !dataManager.getDailyWords(for: userProgress.currentLevel).isEmpty {
                        VStack(spacing: 16) {
                            Text("Сьогоднішні слова")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(dataManager.getDailyWords(for: userProgress.currentLevel).prefix(3)) { word in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(word.german)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(word.ukrainian)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(word.partOfSpeech)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingLevelSelector) {
            LevelSelectorView(selectedLevel: $userProgress.currentLevel)
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .environmentObject(UserProgress())
        .environmentObject(DataManager())
}