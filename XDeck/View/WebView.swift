import SwiftUI
import WebKit
import AppKit

struct WebView: NSViewRepresentable {
    typealias NSViewType = WKWebView

    @Binding var isLoading: Bool
    @Binding var url: URL
    @Binding var alertMessage: String?
    @Binding var messageFromWebView: String?
    @Binding var scriptExecutionRequest: String?

    @AppStorage("pageZoom") var pageZoom: Double = 1

    var refreshSwitch: Bool = false
    var configuration: WKWebViewConfiguration? = nil

    func makeNSView(context: Context) -> WKWebView {
        let webView: WKWebView
        if let configuration = configuration {
            webView = WKWebView(frame: .zero, configuration: configuration)
        } else {
            webView = WKWebView()
        }
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        if let url = webView.url, url != context.coordinator.lastUrl {
            let request = URLRequest(url: url)
            context.coordinator.lastUrl = url
            webView.load(request)
        }
        if refreshSwitch != context.coordinator.refreshSwitch {
            let request = URLRequest(url: url)
            webView.load(request)
            context.coordinator.refreshSwitch = !refreshSwitch
        } else if let script = scriptExecutionRequest {
            webView.evaluateJavaScript(script)
            DispatchQueue.main.async {
                self.scriptExecutionRequest = nil
            }
        }
        if webView.pageZoom != pageZoom {
            webView.pageZoom = CGFloat(pageZoom)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(owner: self)
    }
}

class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    private let owner: WebView
    var lastUrl: URL
    var refreshSwitch: Bool

    init(owner: WebView) {
        self.owner = owner
        self.lastUrl = owner.url
        self.refreshSwitch = false
        super.init()
        owner.configuration?.userContentController.add(self, name: WebViewConfigurations.handlerName)
    }

    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        owner.isLoading = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        owner.isLoading = false
        if let script = owner.scriptExecutionRequest {
            webView.evaluateJavaScript(script)
            owner.scriptExecutionRequest = nil
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if case .linkActivated = navigationAction.navigationType, let url = navigationAction.request.url {
            NSWorkspace.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    // MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        owner.alertMessage = message
    }

    // MARK: WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == WebViewConfigurations.handlerName else { return }
        owner.messageFromWebView = message.body as? String
    }
}
