import Foundation
import WebKit

struct WebViewConfigurations {
    static let handlerName = "handler";

    static var loginConfiguration: WKWebViewConfiguration {
        makeConfiguration(script: wrapOnLoad(contents: [findUserName, findThemeColor]))
    }

    static var topTabConfiguration: WKWebViewConfiguration {
        makeConfiguration(script: wrapOnLoad(contents: [clickTopTab, findThemeColor]))
    }

    static var followingTabConfiguration: WKWebViewConfiguration {
        makeConfiguration(script: wrapOnLoad(contents: [hideHeader, clickFollowingTab]))
    }

    static var commmonConfiguration: WKWebViewConfiguration {
        makeConfiguration(script: wrapOnLoad(contents: [hideHeader]))
    }

    private static func makeConfiguration(script: String) -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        let script = WKUserScript(
            source: script,
            injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(script)
        return configuration
    }

    private static let findUserName: String = """
        waitForElement("a[href$='/lists']", 0, (element) => {
            const userName = element.href.match(/twitter.com\\/(?<userName>.+)\\/lists/).groups.userName;
            const message = JSON.stringify({ type: "userName", body: userName });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        });
    """

    private static let findThemeColor: String = """
        waitForElement("meta[name='theme-color']", 0, (element) => {
            const themeColor = element.getAttribute('content')
            const message = JSON.stringify({ type: "themeColor", body: themeColor });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        });
    """

    private static let hideHeader: String = """
        waitForElement('header', 0, (element) => {
            element.style.display = 'none';
        });
        """

    private static let clickTopTab: String = """
        waitForElement("a[href='/home'][role='tab']", 0, (element) => {
            element.click();
        });
        """

    private static let clickFollowingTab: String = """
        waitForElement("a[href='/home'][role='tab']", 1, (element) => {
            element.click();
        });
        """

    private static func wrapOnLoad(contents: [String]) -> String {
        return """
            \(waitForElement)
            document.addEventListener('DOMContentLoaded', () => {
                \(contents.joined(separator: "\n"))
            });
            """
    }

    private static let waitForElement: String = """
        function waitForElement(selector, index, callback) {
            const observer = new MutationObserver((mutationsList, observer) => {
                const element = document.querySelectorAll(selector)[index];
                if (element) {
                    callback(element);
                    observer.disconnect();
                }
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }
        """
}
