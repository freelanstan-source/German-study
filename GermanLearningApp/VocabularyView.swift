import SwiftUI

struct VocabularyView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedFilter: VocabularyFilter = .all
    @State private var showingWordDetail: VocabularyWord?
    
    enum VocabularyFilter: String, CaseIterable, Identifiable {
        case all = "Всі"
        case learned = "Вивчені"
        case unlearned = "Не вивчені"
        case nouns = "Іменники"
        case verbs = "Дієслова"
        case adjectives = "Прикметники"
        
        var id: String { rawValue }
    }
    
    var filteredWords: [VocabularyWord] {
        let levelWords = dataManager.getVocabularyWords(for: userProgress.currentLevel)
        
        let filtered = levelWords.filter { word in
            let matchesSearch = searchText.isEmpty || 
                word.german.localizedCaseInsensitiveContains(searchText) ||
                word.ukrainian.localizedCaseInsensitiveContains(searchText) ||
                word.english.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter: Bool
            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .learned:
                matchesFilter = userProgress.learnedWords.contains(word.id)
            case .unlearned:
                matchesFilter = !userProgress.learnedWords.contains(word.id)
            case .nouns:
                matchesFilter = word.partOfSpeech.contains("существительное")
            case .verbs:
                matchesFilter = word.partOfSpeech.contains("глагол")
            case .adjectives:
                matchesFilter = word.partOfSpeech.contains("прилагательное")
            }
            
            return matchesSearch && matchesFilter
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Словник")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Рівень \(userProgress.currentLevel.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(userProgress.learnedWords.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("вивчено")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Пошук слів...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Filter buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(VocabularyFilter.allCases) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                }) {
                                    Text(filter.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedFilter == filter ? 
                                                Color.blue : Color.gray.opacity(0.2)
                                        )
                                        .foregroundColor(
                                            selectedFilter == filter ? .white : .primary
                                        )
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                
                // Words list
                if filteredWords.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        
                        Text("Слова не знайдено")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Спробуйте змінити пошуковий запит або фільтр")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    List(filteredWords) { word in
                        VocabularyWordCard(
                            word: word,
                            isLearned: userProgress.learnedWords.contains(word.id)
                        ) {
                            showingWordDetail = word
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(item: $showingWordDetail) { word in
            VocabularyWordDetailView(
                word: word,
                isLearned: userProgress.learnedWords.contains(word.id)
            ) {
                userProgress.markWordLearned(word.id)
            }
        }
    }
}

struct VocabularyWordCard: View {
    let word: VocabularyWord
    let isLearned: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(word.german)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if isLearned {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                    }
                    
                    Text(word.ukrainian)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Text(word.partOfSpeech)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        Text(word.level.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isLearned ? Color.green.opacity(0.05) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isLearned ? Color.green.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
    }
}

#Preview {
    VocabularyView()
        .environmentObject(UserProgress())
        .environmentObject(DataManager())
}