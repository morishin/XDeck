import Foundation

enum AppConfigError: Error {
    case failedToReadFile
    case failedToCreateConfigFile
}

struct AppConfig: Decodable {
    var columnWidth: Int?
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

        var isXColumn: Bool {
            switch type {
            case .following, .forYou, .notifications, .profile:
                return true
            case .custom:
                if let url = url.flatMap({ URL(string: $0)}), ["x.com", "twitter.com"].contains(url.host()) {
                    return true
                }
                return false
            }
        }
    }

    static let configDirectoryUrl = FileManager.default.homeDirectoryForCurrentUser.appending(components: ".config", "XDeck")
    private static let configFileUrl = configDirectoryUrl.appending(path: "settings.json")
    private static let configSchemaFileUrl = configDirectoryUrl.appending(path: "schema.json")
    private static func createConfigFileIfNotExist() throws {
        try FileManager.default.createDirectory(at: configDirectoryUrl, withIntermediateDirectories: true)

        // Create settings.json if not exists
        if !FileManager.default.fileExists(atPath: configFileUrl.path()) {
            guard let initialConfigFile = Bundle.main.path(forResource: "settings", ofType: "json"),
                let initialConfigData = try? Data(contentsOf: URL(filePath: initialConfigFile))
            else { throw AppConfigError.failedToReadFile }
            let isSucceededCreatingConfigFile = FileManager.default.createFile(
                atPath: configFileUrl.path(), contents: initialConfigData)
            guard isSucceededCreatingConfigFile else {
                throw AppConfigError.failedToCreateConfigFile
            }
        }

        // Create or Update schema.json
        guard let schemaFile = Bundle.main.path(forResource: "schema", ofType: "json"),
              let schemaData = try? Data(contentsOf: URL(filePath: schemaFile))
        else { throw AppConfigError.failedToReadFile }
        let isSucceededCreatingSchemaFile = FileManager.default.createFile(
            atPath: configSchemaFileUrl.path(), contents: schemaData)
        guard isSucceededCreatingSchemaFile else {
            throw AppConfigError.failedToCreateConfigFile
        }
    }

    static func loadConfig() -> AppConfig? {
        do {
            try createConfigFileIfNotExist()
            guard let loadedData = FileManager.default.contents(atPath: configFileUrl.path()) else { throw AppConfigError.failedToReadFile }
            return try JSONDecoder().decode(AppConfig.self, from: loadedData)
        } catch {
            print(error.localizedDescription.debugDescription)
            return nil
        }
    }
}
