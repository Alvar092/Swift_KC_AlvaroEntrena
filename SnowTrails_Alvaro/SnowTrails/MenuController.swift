//
//  MenuController.swift
//  SnowTrails
//
//  Created by Ismael Sabri Pérez on 6/2/25.
//

import Foundation
import OSLog

class MenuController {
    private let program: Program
    private let logger: Logging
    
    init(logger: Logging) {
        self.logger = logger
        self.program = Program(logger: logger)
    }
        
    
    func showWelcomeMenu() {
        var exit = false
        
        while !exit {
            logger.logInfo("===Bienvenido a Snowtrails=== \n 1. Acceder como usuario \n 2. Acceder como administrador \n 3. Salir ", for: .user)
            
            if let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !choice.isEmpty {
                switch choice {
                case "1":
                    program.logInApplication(for: .normal, success: {showUserMenu()}, failure: {logger.logError("Credenciales incorrectas", for: .user)})
                    
                case "2":
                    program.logInApplication(for: .admin, success: {showAdminMenu()}, failure: {logger.logError("Credenciales incorrectas", for: .user)})
                    
                case "3":
                    exit = true
                    
                default:
                    logger.logError("Entrada no válida", for: .developer)
                    logger.logError("Opcion no valida, intente de nuevo", for: .user)
                }
            }
        }
    }
    
    func showUserMenu() {
        var exitUserMenu = false
        
        while !exitUserMenu {
            logger.logInfo("Menú de usuario - Selecciona una opción: \n 1. Ver todas las rutas \n 2. Obtener la ruta mas corta entre dos punto \n 3. Log out",for: .user)
            
            if let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !choice.isEmpty {
                switch choice {
                case "1":
                    let routes = program.showPaths()
                    for route in routes {print(route)}
                    
                case "2":
                    program.shortestWayApplication()
                    
                case "3":
                    exitUserMenu = true
                    logger.logInfo("Cerrando sesion...",for: .user)
                    
                default:
                    logger.logError("Entrada no válida", for: .developer)
                    logger.logError("Opcion no valida, intente de nuevo", for: .user)
                    
                }
            }
        }
    }
    
    func showAdminMenu() {
        var exitAdminMenu = false
        while !exitAdminMenu{
            logger.logInfo("Menu de administrador - Selecciona una opción: \n 1. Ver todos los usuarios \n 2. Añadir usuario \n 3. Eliminar usuario \n 4. Añadir punto a una ruta \n 5. Log out", for: .user)
            
            if let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !choice.isEmpty {
                switch choice {
                case "1":
                    let users = program.showUsers()
                    for user in users {
                        logger.logInfo("\(user)", for: .user)
                    }
                case "2":
                    program.readNewUserInfo()
                    
                case "3":
                    program.nameForDeleting()
                    
                case "4":
                    program.addPointApplication()
                    
                case "5":
                    exitAdminMenu = true
                    logger.logInfo("Cerrando sesión...", for: .user)
                    
                default:
                    logger.logError("Entrada no válida", for: .developer)
                    logger.logError("Opción no válida, intentlo de nuevo", for: .user)
                }
            }
        }
    }
    
}




//    func showLoginMenu() {
//        print("Login menu. The number of menus in this app is \(getNumberOfMenus())")
//    }
//
//    func getNumberOfMenus() -> Int {
//        return 3
//    }
