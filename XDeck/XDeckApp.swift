import SwiftUI

@main
struct XDeckApp: App {
    var body: some Scene {
        WindowGroup {
            if let config = AppConfig.loadConfig() {
                ContentView(appConfig: config)
            } else {
                VStack(alignment: .center) {
                    Text("Error: Failed to load config file")
                }
            }
        }.windowStyle(.hiddenTitleBar)
    }
}
