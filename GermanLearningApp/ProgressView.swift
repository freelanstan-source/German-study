import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case week = "Тиждень"
        case month = "Місяць"
        case year = "Рік"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Прогрес навчання")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Відстежуйте ваші досягнення")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Current level and streak
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text(userProgress.currentLevel.rawValue)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("Поточний рівень")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                        
                        VStack(spacing: 8) {
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
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Overall statistics
                    VStack(spacing: 16) {
                        Text("Загальна статистика")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Слова вивчено",
                                value: "\(userProgress.learnedWords.count)",
                                icon: "textformat.abc",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Граматичних тем",
                                value: "\(userProgress.completedGrammarTopics.count)",
                                icon: "book.fill",
                                color: .purple
                            )
                            
                            StatCard(
                                title: "Днів навчання",
                                value: "\(userProgress.streakDays)",
                                icon: "calendar",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Рівень досягнуто",
                                value: userProgress.currentLevel.rawValue,
                                icon: "star.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress by level
                    VStack(spacing: 16) {
                        Text("Прогрес по рівнях")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(LanguageLevel.allCases) { level in
                                LevelProgressCard(
                                    level: level,
                                    isCurrent: userProgress.currentLevel == level,
                                    progress: calculateLevelProgress(for: level)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent activity
                    VStack(spacing: 16) {
                        Text("Остання активність")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if userProgress.dailyProgress.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                
                                Text("Поки що немає даних про активність")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(userProgress.dailyProgress.prefix(5)) { progress in
                                    ActivityCard(progress: progress)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Achievements
                    VStack(spacing: 16) {
                        Text("Досягнення")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            AchievementCard(
                                title: "Перші кроки",
                                description: "Вивчіть 10 слів",
                                icon: "1.circle.fill",
                                isUnlocked: userProgress.learnedWords.count >= 10,
                                color: .green
                            )
                            
                            AchievementCard(
                                title: "Граматик",
                                description: "Завершіть 5 тем",
                                icon: "book.circle.fill",
                                isUnlocked: userProgress.completedGrammarTopics.count >= 5,
                                color: .purple
                            )
                            
                            AchievementCard(
                                title: "Стрік",
                                description: "7 днів поспіль",
                                icon: "flame.fill",
                                isUnlocked: userProgress.streakDays >= 7,
                                color: .orange
                            )
                            
                            AchievementCard(
                                title: "Просунутий",
                                description: "Досягніть рівня B1",
                                icon: "star.circle.fill",
                                isUnlocked: userProgress.currentLevel.rawValue >= "B1",
                                color: .blue
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func calculateLevelProgress(for level: LanguageLevel) -> Double {
        let levelWords = dataManager.getVocabularyWords(for: level)
        let levelTopics = dataManager.getGrammarTopics(for: level)
        
        let learnedWords = levelWords.filter { userProgress.learnedWords.contains($0.id) }.count
        let completedTopics = levelTopics.filter { userProgress.completedGrammarTopics.contains($0.id) }.count
        
        let totalItems = levelWords.count + levelTopics.count
        if totalItems == 0 { return 0.0 }
        
        return Double(learnedWords + completedTopics) / Double(totalItems)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
}

struct LevelProgressCard: View {
    let level: LanguageLevel
    let isCurrent: Bool
    let progress: Double
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(level.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if isCurrent {
                        Text("Поточний")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                }
                
                Text(level.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                ProgressView(value: progress)
                    .frame(width: 60)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrent ? Color.blue.opacity(0.05) : Color.gray.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrent ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
}

struct ActivityCard: View {
    let progress: DailyProgress
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(progress.date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Рівень \(progress.level.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(progress.wordsLearned) слів")
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text("\(progress.grammarTopicsCompleted) тем")
                    .font(.caption)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "uk_UA")
        return formatter.string(from: date)
    }
}

struct AchievementCard: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(isUnlocked ? color : .gray)
            
            Text(title)
                .font(.headline)
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.caption)
                .foregroundColor(isUnlocked ? .secondary : .secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            isUnlocked ? color.opacity(0.1) : Color.gray.opacity(0.05)
        )
        .cornerRadius(16)
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    ProgressView()
        .environmentObject(UserProgress())
        .environmentObject(DataManager())
}