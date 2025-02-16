//
//  Programm.swift
//  SnowTrails
//
//  Created by Álvaro Entrena Casas on 7/2/25.
//

import Foundation
import OSLog


struct Program {
    private let logger: Logging
    
    init(logger: Logging) {
        self.logger = logger
    }
    
    
    // Modo de acceso al data source mediante Singleton
    private let dataSource = TopographicDataSource.shared
    
    
    // Solicitar email y contraseña y validar con validateCredentials()
    func logInApplication(for userType: UserType, success: () -> (), failure: ()-> ()) {
        logger.logInfo("Introduzca su email: ", for: .user)
        guard let email = readLine(), !email.isEmpty else {
            logger.logError("El email no puede estar vacio", for: .user)
            return
        }
        
        logger.logInfo("Introduzca contraseña: ", for: .user)
        guard let password = readLine(), !password.isEmpty else {
            logger.logError("La contraseña esta vacia", for: .user)
            return
        }
        
        if validateCredentials(email: email, password: password, for: userType){
            success()
        } else {
            failure()
        }
    }
    
    // Validar email
    func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@")
        guard parts.count == 2, parts[1].contains(".") else {
            return false
        }
        let validDomains = ["es", "com"]
        if let domainsSuffix = parts[1].split(separator: ".").last {
            return validDomains.contains(String(domainsSuffix))
        }
        return false
    }
    
    // Validar credenciales
    func validateCredentials(email: String, password: String, for usertype: UserType) -> Bool {
        var isValid = false
        
        if let findUser = usersRegistration.first(where: {$0.email == email}) {
            let name = findUser.name
            
            guard (8...24).contains(name.count) else{
                logger.logError("El nombre de usuario debe contener entre 8 y 24 caracteres", for: .user)
                return isValid
            }
            guard isValidEmail(email) else {
                logger.logError("El email no es valido, por favor introduce un email acabado en .es o .com", for: .user)
                return isValid
            }
            isValid = true
            logger.logInfo("Acceso autorizado para \(name) como usuario \(usertype.rawValue)", for: .user)
        }
        else {
            logger.logError("No se encontró el usuario", for: .user)
        }
        return isValid
    }
    
    
    //Formula Haversine
    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let pi = Double.pi
        let radiusEarth = 6371000.00
        let lat1Rad = lat1 * pi / 180
        let lat2Rad = lat2 * pi / 180
        let deltaLat = (lat2 - lat1) * .pi / 180
        let deltaLon = (lon2 - lon1) * .pi / 180
        
        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return radiusEarth * c
    }
    
    //Haversine + Pitagora
    func distanceWithAltitude(lat1: Double, lon1: Double, alt1: Double, lat2: Double? = nil, lon2: Double? = nil, alt2: Double? = nil) -> Double {
        let lat2Final = lat2 ?? lat1
        let lon2Final = lon2 ?? lon1
        let alt2Final = alt2 ?? alt1
        
        
        let surfaceDistance = haversineDistance(lat1: lat1, lon1: lon1, lat2: lat2Final, lon2: lon2Final)
        let altitudeDiference = alt2Final - alt1
        let result = sqrt(pow(surfaceDistance, 2) + pow(altitudeDiference, 2)) / 1000
        return (result * 100).rounded() / 100
    }
    
    
    
    //User-Funcion de mostrar rutas
    func showPaths() -> [String] {
        let dataSource = TopographicDataSource.shared
        
        var totalPaths: [String] = []
        
        logger.logInfo("Calculando la distancia de las rutas", for: .user)
        
        for route in dataSource.routes {
            var totalDistance = 0.0
            
            let routePoints = route.points.compactMap{ pointName in dataSource.topographicPoints.first{$0.name == pointName}}
            
            for i in 0..<(routePoints.count - 1 ) {
                let point1 = routePoints[i]
                let point2 = routePoints[i + 1]
                
                totalDistance += distanceWithAltitude(lat1: point1.latitude, lon1: point1.longitude, alt1: point1.elevation, lat2: point2.latitude, lon2: point2.longitude, alt2: point2.elevation)
            }
            
            let distanceString = String(format: "%.2f", totalDistance)
            totalPaths.append("\(route.name) - \(distanceString) km")
        }
        return totalPaths
    }
    
    
    //User-Funcion de obtener ruta mas corta (en construcción mientras no saque lo básico)
    
    // Primero tenemos que obtener las rutas y sus puntos
    func obtainPathsAndPoints() {
        let dataSource = TopographicDataSource.shared
        
        let routes = dataSource.routes
        for route in routes {
            let pointList = route.points.joined(separator: "\n")
            logger.logInfo("\(route.name) con los siguientes puntos:\n\(pointList)", for: .user)
        }
    }
    
    // Registramos los inputs del usuario
    func shortestWayApplication() {
        logger.logInfo("Elige un punto de inicio:", for: .user)
        obtainPathsAndPoints()
        guard let point1 = readLine(), !point1.isEmpty, dataSource.topographicPoints.contains(where: {$0.name == point1}) else {
            logger.logError("El punto no puede estar vacio y/o tiene que existir", for: .user)
            return
        }
        logger.logInfo("Elige el punto al que quieres llegar:", for: .user)
        obtainPathsAndPoints()
        guard let point2 = readLine(), !point2.isEmpty, dataSource.topographicPoints.contains(where: {$0.name == point2}), point1 != point2 else {
            logger.logError("El punto no puede estar vacio y/o tiene que existir y ser diferente", for: .user)
            return
        }
        obtainShortestWay(from: point1, to: point2, in: transformPointConnections(pointConnections: dataSource.pointConnections))
    }
    
    // Primero transformar nuestro diccionario actual en un diccionario que incluya la distancia
    func transformPointConnections( pointConnections: [String: [String]]) -> [String: [(String, Double)]] {
        var connectionsWithWeight : [String: [(String, Double)]] = [:]
        
        for (point, neighbours) in pointConnections {
            var connectionsWithDistance: [(String, Double)] = []
            
            
            for neighbour in neighbours {
                var minDistance: Double? = nil
                
                for route in dataSource.routes {
                    
                    let routePoints = route.points.compactMap{ pointName in dataSource.topographicPoints.first{$0.name == pointName}}
                    
                    for i in 0..<(routePoints.count - 1 ) {
                        let point1 = routePoints[i]
                        let point2 = routePoints[i + 1]
                        
                        if (point1.name == point && point2.name == neighbour) || (point1.name == neighbour && point2.name == point) {
                            let distance = distanceWithAltitude(
                                lat1: point1.latitude, lon1: point1.longitude, alt1: point1.elevation,
                                lat2: point2.latitude, lon2: point2.longitude, alt2: point2.elevation
                            )
                            
                            if minDistance == nil || distance < minDistance! {
                                minDistance = distance
                            }
                        }
                    }
                }
                if let validDistance = minDistance {
                    connectionsWithDistance.append((neighbour, validDistance))
                }
                connectionsWithWeight[point] = connectionsWithDistance
            }
        }
        return connectionsWithWeight
    }
        
    // Aplicamos el algoritmo de Dijkstra para obtener la ruta mas corta.
    func obtainShortestWay(from point1: String, to point2: String, in graph: [String: [(String, Double)]]) {
        var distances: [String: Double] = [:]
        var previous: [String: String?] = [:]

        // Inicializo todas las distancias en infinito menos el punto de inicio que será 0
        for point in graph.keys {
            distances[point] = Double.greatestFiniteMagnitude
            previous[point] = nil
        }
        distances[point1] = 0.0

        // Cola de prioridad para procesar los puntos ordenados por la distancia mínima
        var priorityQueue = [(point: String, distance: Double)]()
        priorityQueue.append((point1, 0.0))

        while !priorityQueue.isEmpty {
            // Ordenar la cola para extraer el nodo con menor distancia
            priorityQueue.sort { $0.distance < $1.distance }

            // Extraer el nodo con menor distancia
            let (currentPoint, currentDistance) = priorityQueue.removeFirst()

            // Si llegamos al destino, terminamos
            if currentPoint == point2 {
                break
            }

            // Explorar los vecinos y actualizar distancias si encontramos una más corta
            if let neighbours = graph[currentPoint] {
                for (neighbour, weight) in neighbours {
                    let newDistance = currentDistance + weight

                    // Si encontramos una ruta más corta a este vecino, actualizamos
                    if newDistance < distances[neighbour]! {
                        distances[neighbour] = newDistance
                        previous[neighbour] = currentPoint

                        // Agregar al vecino a la cola de prioridad
                        priorityQueue.append((neighbour, newDistance))
                    }
                }
            }
        }

        // Reconstrucción de la ruta más corta
        var path: [String] = []
        var currentPoint: String? = point2

        while let point = currentPoint {
            path.append(point)
            currentPoint = previous[point] ?? nil
        }

        // Invertimos el camino para que vaya de inicio a destino
        let shortestPath = path.reversed()

        // Imprimimos la ruta más corta y la distancia total
        if let totalDistance = distances[point2], totalDistance < Double.greatestFiniteMagnitude {
            logger.logInfo("Ruta más corta: \(shortestPath.joined(separator: " -> "))", for: .user)
            logger.logInfo("Distancia total: \(totalDistance) km", for: .user)
        } else {
            logger.logError("No hay ruta disponible entre \(point1) y \(point2)", for: .user)
        }
    }

        
        
        
        //Admin-mostrar usuarios
        func showUsers() -> [String] {
            var result:[String] = []
            for user in usersRegistration {
                result.append("\(user.type.rawValue): \(user.name)--- Email: \(user.email)")
            }
            return result
        }
        
        
        //Admin-añadir usuario (validamos en createUser)
        func readNewUserInfo() {
            logger.logInfo("Introduce el nombre de usuario que quieres añadir", for: .user)
            guard let nombre = readLine(), !nombre.isEmpty else {
                logger.logError("El nombre no puede estar vacio", for: .user)
                return
            }
            
            logger.logInfo("Introduce el email del usuario que quieres añadir", for: .user)
            guard let email = readLine(), !email.isEmpty else {
                print("El email no puede estar vacio")
                return
            }
            
            logger.logInfo("Introduce la contraseña del usuario que quieres añadir", for: .user)
            guard let password = readLine(), !password.isEmpty else{
                logger.logError("La contraseña no puede estar vacia", for: .user)
                return
            }
            
            let newUser = User(type: .normal, name: nombre, email: email, password: password)
            return createUser(newUser: newUser)
        }
        
        
        // Validaciones de nombre, email y credenciales. Añade usuario al registro.
        func createUser(newUser: User) {
            
            guard !usersRegistration.contains(where: {$0.name == newUser.name}) else{
                logger.logError("El nombre de usuario ya esta registrado", for: .user)
                return
            }
            
            guard (8...24).contains(newUser.name.count) else{
                logger.logError("El nombre de usuario debe contener entre 8 y 24 caracteres", for: .user)
                return
            }
            
            guard newUser.type == .normal else {
                logger.logError("El usuario no cuenta con la categoría adecuada", for: .user)
                return
            }
            
            guard isValidEmail(newUser.email) else {
                logger.logError("El email no es valido, por favor introduce un email acabado en .es o .com", for: .user)
                return
            }
            
            // Usuario valido !
            usersRegistration.append(newUser)
            print(usersRegistration)
            logger.logInfo("Usuario \(newUser.name) con email \(newUser.email) añadido satisfactoriamente", for: .user)
        }
        
        // Admin- solicitar usuario para eliminar
        func nameForDeleting() {
            logger.logInfo("¿Que usuario quieres eliminar?", for: .user)
            guard let name = readLine(), !name.isEmpty else {
                logger.logError("Debes introducir un nombre de usuario", for: .user)
                return
            }
            return deleteUser(userName: name)
        }
        
        //Admin- eliminar usuario
        func deleteUser(userName: String) {
            let initialCount = usersRegistration.count
            usersRegistration.removeAll(where: {$0.name == userName})
            if initialCount == usersRegistration.count {
                logger.logError("No se encontro un usuario con el nombre \(userName)", for: .user)
            } else {
                logger.logInfo("Usuario \(userName) eliminado correctamente", for: .user)
            }
        }
        
        func addPointApplication() {
            logger.logInfo("¿Que punto desea añadir?", for: .user)
            guard let point = readLine(), !point.isEmpty else{
                logger.logError("El nombre del punto no puede estar vacio", for: .user)
                return
            }
            
            logger.logInfo("Introduce el nombre de la ruta a la que quieres añadir el punto", for: .user)
            guard let path = readLine(), !path.isEmpty else{
                logger.logError("El nombre de la ruta no puede estar vacio", for: .user)
                return
            }
            
            logger.logInfo("Si quieres añadirlo en una posición especifica, introduce su valor numérico. Si no, se añadirá al final por defecto", for: .user)
            let inputPosition = readLine()
            
            let position : Int? = inputPosition?.isEmpty == false ? Int(inputPosition!) : nil
            
            addPointToPath(pointName: point, for: path, in: position)
        }
        
        
        //Admin- añadir punto a una ruta(en construcción mientras no saque lo básico)
        func addPointToPath(pointName: String, for route: String, in position: Int? = nil) {
            
            // Verificar que la ruta existe y localizar su indice
            guard let index = dataSource.routes.firstIndex(where: {$0.name == route}) else {
                logger.logError("No se ha encontrado la ruta", for: .user)
                return
            }
            
            // Verificar que el punto no esta en la ruta ya
            if dataSource.routes[index].points.contains(pointName) {
                logger.logError("El punto ya esta añadido a la ruta", for: .user)
                return
            }
            
            // Insertar el punto en la posición especificada o al final.
            if let pos = position, pos >= 0, pos <= dataSource.routes[index].points.count {
                dataSource.routes[index].points.insert(pointName, at: pos)
            } else {
                dataSource.routes[index].points.append(pointName)
            }
            logger.logInfo("El punto \(pointName) se ha añadido a la ruta \(route) correctamente", for: .user)
        }
}
