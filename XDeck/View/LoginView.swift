import SwiftUI

struct LoginView: View {
    @State var isLoading: Bool = false
    @State var url: URL = URL(string: "https://twitter.com/login")!
    @State var scriptExecutionRequest: String? = nil
    @Binding var isShowingAlert: Bool
    @Binding var alertMessage: String?
    @Binding var loginViewMessage: String?

    var body: some View {
        VStack {
            WebView(
                isLoading: $isLoading, url: $url, alertMessage: $alertMessage,
                messageFromWebView: $loginViewMessage,
                scriptExecutionRequest: $scriptExecutionRequest,
                configuration: WebViewConfigurations.loginConfiguration)
        }
        .padding()
        .onChange(of: alertMessage) { message in
            isShowingAlert = message != nil
        }
    }
}
