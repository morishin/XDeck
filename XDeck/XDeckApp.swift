import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    // SwiftUI's WindowGroup persists the window frame to UserDefaults under an
    // auto-generated "NSWindow Frame ..." key and restores it on every launch, which
    // overrides `.defaultSize` and makes the configured columnWidth-based initial size
    // unreliable. Clearing it before the window is created keeps the initial size
    // deterministic and driven by the current config on every launch.
    func applicationWillFinishLaunching(_ notification: Notification) {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("NSWindow Frame ") {
            defaults.removeObject(forKey: key)
        }
    }

    // Without this, macOS restores the window frame from the previous launch, which
    // overrides `.defaultSize` and makes the configured columnWidth-based initial size unreliable.
    func applicationShouldRestoreApplicationState(_ app: NSApplication) -> Bool { false }
    func applicationShouldSaveApplicationState(_ app: NSApplication) -> Bool { false }
}

@main
struct XDeckApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let appConfig = AppConfig.loadConfig()

    var body: some Scene {
        WindowGroup {
            if let appConfig {
                ContentView(appConfig: appConfig)
            } else {
                VStack(alignment: .center) {
                    Text("Error: Failed to load config file")
                }
            }
        }
        .windowStyle(.hiddenTitleBar)
        // A rough starting size shown before login and before the actual column content has
        // rendered. ContentView resizes the window to fit the real rendered content width once
        // it's known, since the exact fit can't be computed in advance (WebView/scrollbar
        // rendering introduces small, hard-to-predict width differences).
        .defaultSize(width: AppConfig.defaultWindowWidth, height: AppConfig.defaultWindowHeight)
    }
}
