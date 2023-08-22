import Foundation

struct WebViewMessage: Decodable {
    var type: MessageType
    var body: String

    enum MessageType: String, Decodable {
        case userName
        case themeColor
    }
}
