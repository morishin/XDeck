import SwiftUI
import WebKit

struct ContentView: View {
    var appConfig: AppConfig

    @AppStorage("pageZoom") var pageZoom: Double = 1
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    @State var isLoading: Bool = false
    @State var isShowingAlert: Bool = false
    @State var alertMessage: String? = nil
    @State var backgroundColor: Color = .white
    @State var columnWidth: CGFloat = 380
    @State var refreshSwitch: Bool = false
    @State var scriptExecutionRequest: String? = nil

    @State var topTabMessage: String? = nil
    @State var followingTabMessage: String? = nil
    @State var notificationsViewMessage: String? = nil
    @State var profileViewMessage: String? = nil
    @State var loginViewMessage: String? = nil

    @State var homeUrl: URL = URL(string: "https://twitter.com/home")!
    @State var notificationsUrl: URL = URL(string: "https://twitter.com/notifications")!
    @State var profileUrl: URL? = nil

    @Environment(\.openURL) private var openURL

    private static let defaultColumnWidth: CGFloat = 380
    private static let sideMenuWidth: CGFloat = 68
    private static let numberOfColumns = 4
    private static func defaultBackgroundColor(isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#17202A") : Color(hex: "#FFFFFF")
    }
    private static func borderColor(for backgroundColor: Color) -> Color {
        backgroundColor == Color.white ? Color(hex: "#EFF3F4") : Color(hex: "#38444D")
    }
    private static func textColor(for backgroundColor: Color) -> Color {
        backgroundColor == Color.white ? Color(hex: "#536471") : Color(hex: "#8b98a5")
    }
    private static func setNightModeCookieScript(isDarkMode: Bool) -> String {
        return """
            document.cookie = "night_mode=\(isDarkMode ? 1 : 0); domain=.twitter.com; path=/";
            location.reload();
        """
    }

    @ViewBuilder
    private func makeColumn(column: AppConfig.Column, index: Int, profileUrl: Binding<URL?>) -> some View {
        let width = index == 0 ? columnWidth + Self.sideMenuWidth : columnWidth
        switch column.type {
        case .forYou:
            WebView(
                isLoading: $isLoading, url: $homeUrl, alertMessage: $alertMessage,
                messageFromWebView: $topTabMessage,
                scriptExecutionRequest: $scriptExecutionRequest,
                refreshSwitch: refreshSwitch,
                configuration: WebViewConfigurations.topTabConfiguration
            ).frame(width: width)
        case .following:
            WebView(
                isLoading: $isLoading, url: $homeUrl, alertMessage: $alertMessage,
                messageFromWebView: $followingTabMessage,
                scriptExecutionRequest: $scriptExecutionRequest,
                refreshSwitch: refreshSwitch,
                configuration: WebViewConfigurations.followingTabConfiguration
            ).frame(width: width)
        case .notifications:
            WebView(
                isLoading: $isLoading, url: $notificationsUrl,
                alertMessage: $alertMessage,
                messageFromWebView: $notificationsViewMessage,
                scriptExecutionRequest: $scriptExecutionRequest,
                refreshSwitch: refreshSwitch,
                configuration: WebViewConfigurations.commmonConfiguration
            ).frame(width: width)
        case .profile:
            if let url = Binding(profileUrl) {
                WebView(
                    isLoading: $isLoading, url: url, alertMessage: $alertMessage,
                    messageFromWebView: $profileViewMessage,
                    scriptExecutionRequest: $scriptExecutionRequest,
                    refreshSwitch: refreshSwitch,
                    configuration: WebViewConfigurations.commmonConfiguration
                ).frame(width: width)
            }
        case .custom:
            if let urlString = column.url, let url = URL(string: urlString) {
                WebView(
                    isLoading: $isLoading, url: .constant(url), alertMessage: $alertMessage,
                    messageFromWebView: $profileViewMessage,
                    scriptExecutionRequest: .constant(nil),
                    refreshSwitch: refreshSwitch,
                    configuration: nil
                ).frame(width: width)
            }
        }
        EmptyView()
    }

    var body: some View {
        ZStack {
            Button("+") {
                pageZoom = pageZoom + 0.2
                columnWidth = Self.defaultColumnWidth * pageZoom
            }.keyboardShortcut("+").opacity(0)
            Button("-") {
                pageZoom = pageZoom - 0.2
                columnWidth = Self.defaultColumnWidth * pageZoom
            }.keyboardShortcut("-").opacity(0)
            Button("r") {
                refreshSwitch = !refreshSwitch
            }.keyboardShortcut("r").opacity(0)
            Button(",") {
                NSWorkspace.shared.open(AppConfig.configDirectoryUrl)
            }.keyboardShortcut(",").opacity(0)
            if profileUrl != nil {
                ScrollView(.horizontal) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(appConfig.columns.indices, id: \.hashValue) { index in
                                makeColumn(column: appConfig.columns[index], index: index, profileUrl: $profileUrl)
                            }
                            Spacer()
                        }
                    }
                    HStack(spacing: 24) {
                        Button {
                            openURL(URL(string: "https://github.com/morishin/XDeck")!)
                        } label: {
                            GitHubIcon().foregroundColor(
                                Self.textColor(for: backgroundColor)
                            ).frame(width: 20, height: 20)
                        }.buttonStyle(.plain).onHover { inside in
                            if inside {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                        AppearanceToggle(isOn: $isDarkMode) {}.onChange(
                            of: isDarkMode,
                            perform: { newValue in
                                scriptExecutionRequest = Self.setNightModeCookieScript(isDarkMode: isDarkMode)
                                backgroundColor = Self.defaultBackgroundColor(isDarkMode: isDarkMode)
                            })
                        Text("⌘+ Zoom In").foregroundColor(Self.textColor(for: backgroundColor))
                        Text("⌘- Zoom out").foregroundColor(Self.textColor(for: backgroundColor))
                        Text("⌘R Refresh").foregroundColor(Self.textColor(for: backgroundColor))
                        Text("⌘, Settings").foregroundColor(Self.textColor(for: backgroundColor))
                        Spacer()
                    }
                    .foregroundColor(Self.textColor(for: backgroundColor))
                    .padding()
                    .overlay(
                        Rectangle()
                            .frame(height: 1, alignment: .top)
                            .foregroundColor(Self.borderColor(for: backgroundColor)),
                        alignment: .top
                    )
                }
            } else {
                LoginView(
                    isShowingAlert: $isShowingAlert,
                    alertMessage: $alertMessage, loginViewMessage: $loginViewMessage)
            }
        }
        .background(backgroundColor)
        .onChange(
            of: loginViewMessage,
            perform: { loginViewMessage in
                if let messageText = loginViewMessage,
                    let messageData = messageText.data(using: .utf8),
                    let message = try? JSONDecoder().decode(
                        WebViewMessage.self, from: messageData)
                {
                    switch message.type {
                    case .userName:
                        if let url = URL(string: "https://twitter.com/\(message.body)") {
                            profileUrl = url
                        }
                    case .themeColor:
                        let color = Color(hex: message.body)
                        backgroundColor = color
                        isDarkMode = color != Color.white
                    }
                }
            }
        )
        .onChange(
            of: topTabMessage,
            perform: { topTabMessage in
                if let messageText = topTabMessage,
                    let messageData = messageText.data(using: .utf8),
                    let message = try? JSONDecoder().decode(
                        WebViewMessage.self, from: messageData),
                    case .themeColor = message.type
                {
                    let color = Color(hex: message.body)
                    backgroundColor = color
                    isDarkMode = color != Color.white
                }
            }
        )
        .onChange(of: alertMessage) { message in
            isShowingAlert = message != nil
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(alertMessage ?? ""))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private static var defaultConfig: AppConfig {
        return AppConfig(columns: [
            AppConfig.Column(type: .forYou),
            AppConfig.Column(type: .following),
            AppConfig.Column(type: .notifications),
            AppConfig.Column(type: .profile),
        ])
    }

    static var previews: some View {
        ContentView(appConfig: defaultConfig)
            .frame(minWidth: 1280, minHeight: 900)
    }
}
