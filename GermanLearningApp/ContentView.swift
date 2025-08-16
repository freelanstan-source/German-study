import SwiftUI

struct ContentView: View {
    @StateObject private var userProgress = UserProgress()
    @StateObject private var dataManager = DataManager()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Головна")
                }
            
            GrammarView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Граматика")
                }
            
            VocabularyView()
                .tabItem {
                    Image(systemName: "textformat.abc")
                    Text("Слова")
                }
            
            DailyStudyView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Щоденно")
                }
            
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Прогрес")
                }
        }
        .environmentObject(userProgress)
        .environmentObject(dataManager)
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}