//
//  logger.swift
//  SnowTrails
//
//  Created by Álvaro Entrena Casas on 10/2/25.
//

import Foundation
import OSLog


// MARK: Implementación del protocolo para inyección de dependencias
protocol Logging{
    func logInfo(_ message: String, for Category: LogCategory)
    func logError(_ message: String, for category: LogCategory)
}

enum LogCategory {
    case user
    case developer
}

class AppLogger: Logging {
    
    
    private let userLogger: Logger
    private let developerLogger: Logger
    
    init(subsystem: String) {
        self.userLogger = Logger(subsystem: "SnowTrails", category: "LogsDelUsuario")
        self.developerLogger = Logger(subsystem: "SnowTrails", category: "LogsDelDesarrollador")
        }
    
    func logInfo(_ message: String, for category: LogCategory) {
        let logger = loggerFor(category)
        logger.info("\(message)")
    }
                         
    func logError(_ message: String, for category: LogCategory) {
        let logger = loggerFor(category)
        logger.error("\(message)")
    }
    
    func loggerFor(_ category: LogCategory) -> Logger {
        return category == .user ? userLogger : developerLogger
    }
}

// MARK: Ejemplo de cómo diferenciar entre logs para el usuario y logs para el desarrollador
//extension Logger {
//    static let consoleUILogger = Logger(subsystem: "SnowTrails", category: "LogsDelUsuario")
//    static let consoleDeveloperLogger = Logger(subsystem: "SnowTrails", category: "LogsDelDesarrollador")
//}
