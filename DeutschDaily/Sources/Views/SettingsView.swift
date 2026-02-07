import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var notificationsEnabled: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Рівень та план")) {
                    Picker("Рівень", selection: Binding(get: { appState.selectedLevel }, set: { appState.setLevel($0) })) {
                        ForEach(Level.allCases) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                    Stepper(value: Binding(get: { appState.wordsPerDay }, set: { appState.setWordsPerDay($0) }), in: 1...30) {
                        Text("Слів на день: \(appState.wordsPerDay)")
                    }
                }
                Section(header: Text("Нагадування")) {
                    Toggle("Щоденне нагадування", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { value in
                            if value {
                                appState.onAppLaunch()
                                NotificationScheduler().scheduleDailyReminder()
                            } else {
                                NotificationScheduler().cancelDailyReminder()
                            }
                        }
                }
                Section {
                    Button(role: .destructive) {
                        appState.resetProgress()
                    } label: {
                        Text("Скинути прогрес")
                    }
                }
            }
            .navigationTitle("Налаштування")
        }
    }
}

#Preview {
    SettingsView().environmentObject(AppState())
}