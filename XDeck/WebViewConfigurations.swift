import Foundation
import WebKit

struct WebViewConfigurations {
    enum OnLoadScript {
        case global
        case findUserName
        case findThemeColor
        case clickForYouTab
        case hidePostArea
        case clickFollowingTab
        case hideSideHeader
        case hideAds
        case hideUnverifiedReplies
        case detectMediaOverlay(columnIndex: Int)

        var scriptContent: String {
            switch self {
            case .global: return WebViewConfigurations.global
            case .findUserName: return WebViewConfigurations.findUserName
            case .findThemeColor: return WebViewConfigurations.findThemeColor
            case .clickForYouTab: return WebViewConfigurations.clickForYouTab
            case .hidePostArea: return WebViewConfigurations.hidePostArea
            case .clickFollowingTab: return WebViewConfigurations.clickFollowingTab
            case .hideSideHeader: return WebViewConfigurations.hideSideHeader
            case .hideAds: return WebViewConfigurations.hideAds
            case .hideUnverifiedReplies: return WebViewConfigurations.hideUnverifiedReplies
            case .detectMediaOverlay(let columnIndex): return WebViewConfigurations.detectMediaOverlay(columnIndex: columnIndex)
            }
        }

        var runAfterLoad: Bool {
            switch self {
            case .findUserName, .findThemeColor, .clickForYouTab, .clickFollowingTab, .hideSideHeader, .hidePostArea, .hideAds, .hideUnverifiedReplies:
                return true
            case .global, .detectMediaOverlay:
                return false
            }
        }
    }

    static let handlerName = "handler";

    static func makeConfiguration(onLoadScripts: [OnLoadScript]) -> WKWebViewConfiguration {
        let script = [
            onLoadScripts.filter({ !$0.runAfterLoad }).map(\.scriptContent).joined(separator: "\n"),
            wrapOnLoad(contents: onLoadScripts.filter({ $0.runAfterLoad }).map(\.scriptContent)),
        ].joined(separator: "\n")
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        return configuration
    }

    private static let global: String = """
        window.onerror = function(msg, url, line, column, error) {
            const message = JSON.stringify({ type: "debug", body: `❌️ ${msg}` });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        };
        window.console.error = function(msg) {
            const message = JSON.stringify({ type: "debug", body: `❌️ ${msg}` });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        };
        window.console.warn = function(msg) {
            const message = JSON.stringify({ type: "debug", body: `⚠️ ${msg}` });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        };
        window.console.info = function(msg) {
            const message = JSON.stringify({ type: "debug", body: `ℹ️ ${msg}` });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        };
        window.console.log = function(msg) {
            const message = JSON.stringify({ type: "debug", body: `ℹ️ ${msg}` });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        };

        \(getElementsByXPath)

        \(waitForElement)
    """

    private static let hidePostArea: String = """
        const style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = "div:has(> main):has(> :nth-child(4)) > main div:has(> div > div[role='progressbar']) { display: none; }";
        document.querySelector('head').appendChild(style);
    """

    private static let findUserName: String = """
        waitForElement("a[aria-label='Profile'], a[data-testid='AppTabBar_Profile_Link']", 0, (element) => {
            const href = element.getAttribute('href') || element.href || '';
            let userName = null;
            try {
                const url = new URL(href, window.location.origin);
                const segments = url.pathname.split('/').filter(Boolean);
                userName = segments[0] || null;
            } catch (_) {}
            if (userName) {
                const message = JSON.stringify({ type: "userName", body: userName });
                webkit.messageHandlers.\(Self.handlerName).postMessage(message);
            }
        });
    """

    private static let findThemeColor: String = """
        waitForElement("meta[name='theme-color']", 0, (element) => {
            const themeColor = element.getAttribute('content')
            const message = JSON.stringify({ type: "themeColor", body: themeColor });
            webkit.messageHandlers.\(Self.handlerName).postMessage(message);
        });
    """

    private static let hideSideHeader: String = """
        const style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = "header { display: none !important; }";
        document.querySelector('head').appendChild(style);
        """

    private static let clickForYouTab: String = """
        waitForElement("main [role='tablist'] [role='tab']", 0, (element) => {
            element.click();
        });
        """

    private static let clickFollowingTab: String = """
        waitForElement("main [role='tablist'] [role='tab']", 1, (element) => {
            element.click();
        });
        """

    private static func wrapOnLoad(contents: [String]) -> String {
        return """
            \(waitForElement)
            document.addEventListener('DOMContentLoaded', () => {
                \(contents.map {
                    """
                    (() => {
                        \($0)
                    })();
                    """
                }.joined(separator: "\n"))
            });
            """
    }

    private static let waitForElement: String = """
        function waitForElement(selector, index, callback, once=true) {
            const findElement = () => document.querySelectorAll(selector)[index];
            const existingElement = findElement();
            if (existingElement) {
                callback(existingElement);
                if (once) {
                    return;
                }
            }

            const observer = new MutationObserver((mutationsList, observer) => {
                const element = findElement();
                if (element) {
                    callback(element);
                    if (once) {
                        observer.disconnect();
                    }
                }
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }
        """

    private static let getElementsByXPath: String = """
        function getElementsByXPath(xpath, parent) {
          let results = [];
          let query = document.evaluate(
            xpath,
            parent || document,
            null,
            XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
            null
          );
          for (let i = 0, length = query.snapshotLength; i < length; i++) {
            results.push(query.snapshotItem(i));
          }
          return results;
        }
        """

    static let hideAds: String = """
        function hideAds() {
          const cells = document.querySelectorAll('div[data-testid="cellInnerDiv"]');
          cells.forEach((cell) => {
            if (cell.querySelector('div[data-testid="placementTracking"]')) {
              cell.style.display = "none";
            }
          });
        }

        if (!window.hideAdsMutationObserver) {
          let hideAdsTimer;
          let observer = new MutationObserver(() => {
            clearTimeout(hideAdsTimer);
            hideAdsTimer = setTimeout(hideAds, 100);
          });

          observer.observe(document.body, {
            childList: true,
            subtree: true,
          });

          window.hideAdsMutationObserver = observer;
        }

        hideAds();
        """

    static let showAds: String = """
        (() => {
          if (window.hideAdsMutationObserver) {
            window.hideAdsMutationObserver.disconnect();
            window.hideAdsMutationObserver = null;
          }

          const cells = document.querySelectorAll('div[data-testid="cellInnerDiv"]');
          cells.forEach((cell) => {
            if (cell.querySelector('div[data-testid="placementTracking"]')) {
              cell.style.display = "flex";
            }
          });
        })();
    """

    static let hideUnverifiedReplies: String = """
        (() => {
          const hiddenReplyAttribute = "data-xdeck-unverified-reply";
          const statusPathPattern = /^\\/[^/]+\\/status\\/(\\d+)/;

          function restoreUnverifiedReplies() {
            document.querySelectorAll(`[${hiddenReplyAttribute}]`).forEach((cell) => {
              cell.removeAttribute(hiddenReplyAttribute);
            });
          }

          function isBlueVerified(article) {
            const author = article.querySelector('div[data-testid="User-Name"]');
            if (!author) {
              return false;
            }
            const badges = author.querySelectorAll(
              'svg[data-testid="icon-verified"], svg[aria-label="Verified account"]'
            );
            return Array.from(badges).some((badge) => {
              let element = badge;
              for (let depth = 0; element && depth < 4; depth += 1, element = element.parentElement) {
                const color = getComputedStyle(element).color.replace(/\\s/g, "");
                if (color === "rgb(29,155,240)") {
                  return true;
                }
              }
              return false;
            });
          }

          function statusIdForArticle(article) {
            const timestamp = article.querySelector("time");
            const permalink = timestamp && timestamp.closest('a[href*="/status/"]');
            const match = permalink && new URL(permalink.href, location.origin).pathname.match(statusPathPattern);
            return match ? match[1] : null;
          }

          function filterUnverifiedReplies() {
            const pageMatch = location.pathname.match(statusPathPattern);
            if (!pageMatch) {
              restoreUnverifiedReplies();
              return;
            }

            const mainStatusId = pageMatch[1];
            document.querySelectorAll('div[data-testid="cellInnerDiv"]').forEach((cell) => {
              const article = cell.querySelector('article[data-testid="tweet"]');
              if (!article) {
                return;
              }

              const statusId = statusIdForArticle(article);
              if (!statusId) {
                return;
              }
              const isMainPost = statusId === mainStatusId;
              if (!isMainPost && !isBlueVerified(article)) {
                cell.setAttribute(hiddenReplyAttribute, "true");
              } else {
                cell.removeAttribute(hiddenReplyAttribute);
              }
            });
          }

          if (!document.getElementById("xdeck-verified-replies-style")) {
            const style = document.createElement("style");
            style.id = "xdeck-verified-replies-style";
            style.textContent = `[${hiddenReplyAttribute}] { display: none !important; }`;
            document.head.appendChild(style);
          }

          if (window.xdeckVerifiedRepliesObserver) {
            window.xdeckVerifiedRepliesObserver.disconnect();
          }
          let filterTimer;
          window.xdeckVerifiedRepliesObserver = new MutationObserver(() => {
            clearTimeout(filterTimer);
            filterTimer = setTimeout(filterUnverifiedReplies, 100);
          });
          window.xdeckVerifiedRepliesObserver.observe(document.body, {
            childList: true,
            subtree: true,
          });

          window.xdeckFilterUnverifiedReplies = filterUnverifiedReplies;
          filterUnverifiedReplies();
        })();
    """

    static let showUnverifiedReplies: String = """
        (() => {
          if (window.xdeckVerifiedRepliesObserver) {
            window.xdeckVerifiedRepliesObserver.disconnect();
            window.xdeckVerifiedRepliesObserver = null;
          }
          document.querySelectorAll('[data-xdeck-unverified-reply]').forEach((cell) => {
            cell.removeAttribute('data-xdeck-unverified-reply');
          });
        })();
    """

    private static func detectMediaOverlay(columnIndex: Int) -> String {
        return """
            (function() {
                var mediaExpanded = false;
                const originalPushState = history.pushState;
                history.pushState = function() {
                    originalPushState.apply(this, arguments);
                    const url = window.location.href;
                    if (!mediaExpanded && /\\/(photo|video)\\/\\d+/.test(url)) {
                        mediaExpanded = true;
                        const message = JSON.stringify({ type: "mediaOverlay", body: String(\(columnIndex)) });
                        webkit.messageHandlers.\(Self.handlerName).postMessage(message);
                    }
                };
                window.addEventListener('popstate', function() {
                    const url = window.location.href;
                    if (mediaExpanded && !/\\/(photo|video)\\/\\d+/.test(url)) {
                        mediaExpanded = false;
                        const message = JSON.stringify({ type: "mediaOverlay", body: "close" });
                        webkit.messageHandlers.\(Self.handlerName).postMessage(message);
                    }
                });
            })();
        """
    }
}
