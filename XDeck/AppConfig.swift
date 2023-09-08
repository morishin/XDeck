import Foundation

struct AppConfig: Decodable {
    var columns: [Column]

    struct Column: Decodable {
        enum ColumnType: String, Decodable {
            case forYou
            case following
            case notifications
            case profile
            case custom
        }

        var type: ColumnType
        var url: String?
    }

    static var defaultConfig: AppConfig {
        return AppConfig(columns: [
            Column(type: .forYou),
            Column(type: .following),
            Column(type: .notifications),
            Column(type: .profile),
        ])
    }
}
