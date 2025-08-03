import OSLog

enum LogLevel: String {
    case info = "INFO"
    case error = "ERROR"
}

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "test.test"
    private static let logger = OSLog(subsystem: subsystem, category: "App")

    static func log(_ level: LogLevel, _ message: String) {
        let fullMessage = "[\(level.rawValue)] \(message)"
        switch level {
        case .info:
            os_log("%{public}@", log: logger, type: .info, fullMessage)
        case .error:
            os_log("%{public}@", log: logger, type: .error, fullMessage)
        }
    }

    static func info(_ message: String) {
        log(.info, message)
    }

    static func error(_ message: String) {
        log(.error, message)
    }
}
