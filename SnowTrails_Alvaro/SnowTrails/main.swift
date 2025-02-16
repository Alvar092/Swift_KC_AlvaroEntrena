//
//  main.swift
//  SnowTrails
//
//  Created by Ismael Sabri Pérez on 6/2/25.
//

import Foundation
import OSLog

func main() {
    App().run()
    
    Logger().debug("Mensaje cualquiera")
    Logger().info("Mensaje informativo")
    Logger().error("Mensaje de error")
    Logger().fault("Mensaje de fallo")
    
//    Logger.consoleUILogger.debug("Mensaje al usuario modo debug")
}



main()
