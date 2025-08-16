import SwiftUI

struct DailyStudyView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var dataManager: DataManager
    @State private var currentWordIndex = 0
    @State private var showingAnswer = false
    @State private var showingReview = false
    @State private var studyMode: StudyMode = .newWords
    
    enum StudyMode: String, CaseIterable, Identifiable {
        case newWords = "Нові слова"
        case review = "Повторення"
        
        var id: String { rawValue }
    }
    
    var dailyWords: [VocabularyWord] {
        dataManager.getDailyWords(for: userProgress.currentLevel, count: 5)
    }
    
    var reviewWords: [VocabularyWord] {
        dataManager.getWordsForReview(for: userProgress.currentLevel)
    }
    
    var currentWords: [VocabularyWord] {
        switch studyMode {
        case .newWords:
            return dailyWords
        case .review:
            return reviewWords
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Щоденне вивчення")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Рівень \(userProgress.currentLevel.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    
                    // Mode selector
                    Picker("Режим вивчення", selection: $studyMode) {
                        ForEach(StudyMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Progress indicator
                    if !currentWords.isEmpty {
                        HStack {
                            Text("Прогрес: \(currentWordIndex + 1) з \(currentWords.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            ProgressView(value: Double(currentWordIndex + 1), total: Double(currentWords.count))
                                .frame(width: 100)
                        }
                    }
                }
                .padding()
                
                // Content
                if currentWords.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: studyMode == .newWords ? "checkmark.circle" : "star")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text(studyMode == .newWords ? "Всі слова вивчено!" : "Немає слів для повторення")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        Text(studyMode == .newWords ? 
                             "Ви успішно вивчили всі слова на сьогодні. Повертайтеся завтра за новими словами!" :
                             "Всі слова були нещодавно повторені. Спробуйте завтра або переключіться на нові слова.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if studyMode == .review {
                            Button("Перейти до нових слів") {
                                studyMode = .newWords
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    // Word study card
                    VStack(spacing: 24) {
                        Spacer()
                        
                        // Word card
                        VStack(spacing: 20) {
                            Text(currentWords[currentWordIndex].german)
                                .font(.system(size: 48, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            if showingAnswer {
                                VStack(spacing: 16) {
                                    Text(currentWords[currentWordIndex].ukrainian)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                    
                                    Text(currentWords[currentWordIndex].english)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    
                                    Text(currentWords[currentWordIndex].partOfSpeech)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .cornerRadius(16)
                                    
                                    if !currentWords[currentWordIndex].example.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Приклад:")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Text(currentWords[currentWordIndex].example)
                                                .font(.body)
                                                .italic()
                                                .foregroundColor(.primary)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.orange.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            if !showingAnswer {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingAnswer = true
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "eye")
                                        Text("Показати переклад")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                }
                            } else {
                                HStack(spacing: 16) {
                                    Button(action: {
                                        // Mark as difficult
                                        currentWordIndex = min(currentWordIndex + 1, currentWords.count - 1)
                                        showingAnswer = false
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "xmark.circle")
                                            Text("Складно")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(12)
                                    }
                                    
                                    Button(action: {
                                        // Mark as learned
                                        userProgress.markWordLearned(currentWords[currentWordIndex].id)
                                        currentWordIndex = min(currentWordIndex + 1, currentWords.count - 1)
                                        showingAnswer = false
                                        
                                        if currentWordIndex >= currentWords.count {
                                            showingReview = true
                                        }
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.circle")
                                            Text("Вивчив")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingReview) {
            StudyCompletionView(
                wordsLearned: currentWords.count,
                mode: studyMode
            )
        }
    }
}

struct StudyCompletionView: View {
    let wordsLearned: Int
    let mode: DailyStudyView.StudyMode
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Відмінно!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Ви успішно \(mode == .newWords ? "вивчили" : "повторили") \(wordsLearned) слів")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                Text("Продовжуйте регулярно займатися для кращих результатів")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button("Готово") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DailyStudyView()
        .environmentObject(UserProgress())
        .environmentObject(DataManager())
}