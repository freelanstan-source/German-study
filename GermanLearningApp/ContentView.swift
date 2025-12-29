import SwiftUI

struct ContentView: View {
    @State private var words: [Word] = SampleData.words
    @State private var showOnlyFavorites = false

    var filtered: [Word] {
        showOnlyFavorites ? words.filter { $0.isFavorite } : words
    }

    var body: some View {
        NavigationView {
            List {
                Toggle("Only favorites", isOn: $showOnlyFavorites)
                ForEach(filtered) { word in
                    NavigationLink(destination: WordDetailView(word: binding(for: word))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(word.german).font(.headline)
                                Text(word.partOfSpeech).font(.subheadline).foregroundColor(.secondary)
                            }
                            Spacer()
                            if word.isFavorite {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("German Study")
        }
    }

    private func binding(for word: Word) -> Binding<Word> {
        guard let index = words.firstIndex(where: { $0.id == word.id }) else {
            return .constant(word)
        }
        return $words[index]
    }
}

struct WordDetailView: View {
    @Binding var word: Word
    @State private var showTranslation = false

    var body: some View {
        VStack(spacing: 20) {
            Text(word.german)
                .font(.largeTitle)
                .padding()

            if showTranslation {
                Text(word.translation)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
            } else {
                Text("Tap to reveal translation")
                    .foregroundColor(.secondary)
            }

            Button(showTranslation ? "Hide" : "Reveal") {
                withAnimation { showTranslation.toggle() }
            }
            .buttonStyle(.borderedProminent)

            Button(word.isFavorite ? "Unfavorite" : "Favorite") {
                word.isFavorite.toggle()
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle(word.german)
    }
}
