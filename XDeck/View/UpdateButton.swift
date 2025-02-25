import SwiftUI

struct UpdateButton: View {
    @State private var updateAvailable: Bool = false
    @State private var latestVersion: String? = nil
    @Environment(\.openURL) private var openURL

    private static var currentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    private static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    var body: some View {
        if let currentVersion = Self.currentVersion {
            HStack {
                if updateAvailable, let latestVersion = latestVersion {
                    HStack {
                        Text("v\(currentVersion) (v\(latestVersion) is available)")
                        Button("Update", action: {
                            openURL(URL(string: "https://github.com/morishin/XDeck/releases/latest")!)
                        })
                        .buttonStyle(.bordered)
                    }
                } else {
                    Button("v\(currentVersion)" + (Self.isDebug ? " (dev)" : ""), action: {
                        openURL(URL(string: "https://github.com/morishin/XDeck/releases/tag/\(currentVersion)")!)
                    }).buttonStyle(.plain)
                }
            }
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
            .onAppear {
                Task {
                    await checkForUpdate()
                }
            }
        } else {
            EmptyView()
        }
    }

    func checkForUpdate() async {
        guard let url = URL(string: "https://github.com/morishin/XDeck/releases/latest") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let latestReleaseUrlString = response.url?.absoluteString {
                let latestVersion = extractVersion(from: latestReleaseUrlString)
                let currentVersion = Self.currentVersion ?? "0.0"
                if currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
                    DispatchQueue.main.async {
                        self.latestVersion = latestVersion
                        self.updateAvailable = true
                    }
                }
            }
        } catch {
            self.latestVersion = nil
            self.updateAvailable = false
        }
    }

    func extractVersion(from url: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: "/tag/([0-9]+\\.[0-9]+)"),
              let match = regex.firstMatch(in: url, range: NSRange(location: 0, length: url.utf16.count)),
              let range = Range(match.range(at: 1), in: url) else {
            return "0.0"
        }
        return String(url[range])
    }
}

#Preview {
    UpdateButton().frame(maxWidth: .infinity)
}
