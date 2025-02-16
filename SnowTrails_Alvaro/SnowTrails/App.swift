//
//  App.swift
//  SnowTrails
//
//  Created by Ismael Sabri Pérez on 6/2/25.
//

import Foundation

class App {
    
    let logger = AppLogger(subsystem: "SnowTrails")
    
    let menuController: MenuController
    
    init() {
        self.menuController = MenuController(logger: logger)
    }
    
    func run() {
        menuController.showWelcomeMenu()
    }
}
