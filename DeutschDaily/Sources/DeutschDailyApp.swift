import SwiftUI
import UserNotifications

@main
struct DeutschDailyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    appState.onAppLaunch()
                }
        }
    }
}