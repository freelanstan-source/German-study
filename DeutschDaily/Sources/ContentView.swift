import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Label("Слова", systemImage: "book")
                }

            ReviewView()
                .tabItem {
                    Label("Перевірка", systemImage: "checkmark.circle")
                }

            GrammarView()
                .tabItem {
                    Label("Граматика", systemImage: "text.book.closed")
                }

            SettingsView()
                .tabItem {
                    Label("Налаштування", systemImage: "gearshape")
                }
        }
        .onAppear {
            appState.refreshForCurrentDayIfNeeded()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}