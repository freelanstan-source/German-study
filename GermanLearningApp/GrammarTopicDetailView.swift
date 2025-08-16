import SwiftUI

struct GrammarTopicDetailView: View {
    let topic: GrammarTopic
    let isCompleted: Bool
    let onComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingExamples = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text(topic.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text(topic.level.rawValue)
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(20)
                            
                            if isCompleted {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Завершено")
                                        .foregroundColor(.green)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                    
                    // Explanation
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Пояснення")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(topic.explanation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                    
                    // Examples
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Приклади")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showingExamples.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(showingExamples ? "Приховати" : "Показати")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    
                                    Image(systemName: showingExamples ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                        }
                        
                        if showingExamples {
                            VStack(spacing: 12) {
                                ForEach(topic.examples.indices, id: \.self) { index in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                        
                                        Text(topic.examples[index])
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .lineSpacing(2)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.blue.opacity(0.05))
                                    .cornerRadius(12)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Practice section
                    if !isCompleted {
                        VStack(spacing: 16) {
                            Text("Практика")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Прочитайте пояснення та приклади кілька разів, щоб краще зрозуміти тему.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                onComplete()
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle")
                                    Text("Завершити тему")
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
    GrammarTopicDetailView(
        topic: GrammarTopic(
            title: "Артиклі (der, die, das)",
            explanation: "В німецькій мові існує три артиклі: der (чоловічий рід), die (жіночий рід), das (середній рід).",
            examples: [
                "der Mann (чоловік) - чоловічий рід",
                "die Frau (жінка) - жіночий рід"
            ],
            level: .a1
        ),
        isCompleted: false
    ) {}
}