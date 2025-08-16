import SwiftUI

struct VocabularyWordDetailView: View {
    let word: VocabularyWord
    let isLearned: Bool
    let onLearn: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingTranslation = false
    @State private var showingExample = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Text(word.german)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 12) {
                            Text(word.level.rawValue)
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(20)
                            
                            Text(word.partOfSpeech)
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(20)
                        }
                        
                        if isLearned {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Вивчено")
                                    .foregroundColor(.green)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(20)
                        }
                    }
                    .padding()
                    
                    // Ukrainian translation
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Українською")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showingTranslation.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(showingTranslation ? "Приховати" : "Показати")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    
                                    Image(systemName: showingTranslation ? "eye.slash" : "eye")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        if showingTranslation {
                            Text(word.ukrainian)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.05))
                                .cornerRadius(12)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal)
                    
                    // English translation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Англійською")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(word.english)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Example sentence
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Приклад використання")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showingExample.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(showingExample ? "Приховати" : "Показати")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    
                                    Image(systemName: showingExample ? "eye.slash" : "eye")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        if showingExample {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(word.example)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .italic()
                                
                                Text("Переклад: \(word.ukrainian)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange.opacity(0.05))
                            .cornerRadius(12)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Learning section
                    if !isLearned {
                        VStack(spacing: 16) {
                            Text("Вивчення")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Прочитайте слово кілька разів, переклад та приклад. Спробуйте скласти власне речення з цим словом.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                onLearn()
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle")
                                    Text("Вивчив слово")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VocabularyWordDetailView(
        word: VocabularyWord(
            german: "Haus",
            ukrainian: "будинок",
            english: "house",
            level: .a1,
            partOfSpeech: "существительное",
            example: "Das ist mein Haus."
        ),
        isLearned: false
    ) {}
}