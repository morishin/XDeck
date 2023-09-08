import SwiftUI

@main
struct XDeckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(appConfig: AppConfig.defaultConfig)
        }.windowStyle(.hiddenTitleBar)
    }
}
