//
//  SnowTrailsTesting.swift
//  SnowTrailsTesting
//
//  Created by Ismael Sabri Pérez on 6/2/25.
//

import Testing


// Aquí podéis cambiarle el nombre y añadir más tests de otra clase, struct o archivo
struct SnowTrailsTesting {
    
    class programmTesting{
        
        var program: Program
        var logger: Logging
        let dataSource = TopographicDataSource.shared
        var users = usersRegistration
        
        init() {
            logger = AppLogger(subsystem: "SnowTrails")
            program = Program(logger: logger)
        }
        
        
        
        @Test func distanceWithAltitud()   {
            
            let pointConnections: [String: [String]] = [
                "Alpina Grande": ["Pico Nevado", "Valle Blanco", "Cumbre Azul", "Alpina Pequeña"],
                "Alpina Pequeña": ["Alpina Grande"],
                "Pico Nevado": ["Alpina Grande", "Lago Helado", "Cerro Plateado"],
                "Valle Blanco": ["Alpina Grande", "Refugio Alpino"],
                "Cumbre Azul": ["Alpina Grande", "Cerro Plateado"],
                "Lago Helado": ["Pico Nevado", "Bosque Nevado"],
                "Bosque Nevado": ["Lago Helado", "Cascada Blanca", "Cerro Plateado"],
                "Cerro Plateado": ["Pico Nevado", "Cumbre Azul", "Bosque Nevado", "Cascada Blanca"],
                "Cascada Blanca": ["Cerro Plateado", "Bosque Nevado"],
                "Refugio Alpino": ["Valle Blanco"],
                "Refugio Aislado": [] // No tiene conexiones
            ]
            
            let point1 = TopographicPoint(name: "Alpina Grande", latitude: 46.0000, longitude: 7.5000, elevation: 1500.0, connections: pointConnections["Alpina Grande"] ?? [] )
            
            let point2 = TopographicPoint(name: "Alpina Pequeña", latitude: 46.0022, longitude: 7.5200, elevation: 1200.0, connections: pointConnections["Alpina Pequeña"] ?? [] )
            
            let distance = program.distanceWithAltitude(lat1: point1.latitude, lon1: point1.longitude, alt1: point1.elevation, lat2: point2.latitude, lon2: point2.longitude, alt2: point2.elevation)
            
            #expect(distance == 1.59)
            
        }
        
        @Test func distanceWithAltitud_when_only_one_point()   {
            let datasource = TopographicDataSource.shared
            guard let point = datasource.topographicPoints.first(where: {$0.connections.isEmpty}) else{
                #expect(Bool(false), "No hay puntos")
                return
            }
            let distance = program.distanceWithAltitude(lat1: point.latitude, lon1: point.longitude, alt1: point.elevation, lat2: nil, lon2: nil, alt2: nil)
            
            #expect(distance == 0 )
        }
        
        
        @Test func showPaths()   {
            let dataSource = TopographicDataSource.shared
            
            let paths = program.showPaths()
            
            #expect(paths.count == dataSource.routes.count)
        }
        
        @Test func validateCredentials_forNormalUser()   {
            let email = normalUserDefault.email
            let password = normalUserDefault.password
            //            let type = normalUserDefault.type
            
            let isNormal = program.validateCredentials(email: email, password: password, for: .normal)
            #expect(isNormal == true)
        }
        
        @Test func validateCredentials_forAdminUser()   {
            let email = administratorUserDefault.email
            let password = administratorUserDefault.password
            //            let userType = administratorUserDefault.type
            let isAdmin = program.validateCredentials(email: email, password: password, for: .admin)
            #expect(isAdmin == true)
        }
        
        @Test func validateCredentialsWhenUserDoesntExists() {
            let email = "ejemplofalso@correofrio.net"
            let result = program.validateCredentials(email: email, password: "12345", for: .normal)
            #expect(result == false)
        }
        
        @Test func showUsers() {
            let users = program.showUsers()
            #expect((users.count == usersRegistration.count))
        }
        
        @Test func addPointToPath() {
            let point = "Cerro Plateado"
            let pathName = "Ruta del Pico Nevado y Lago Helado"
            // Cantidad de puntos de inicio
            let initialCount = dataSource.routes.first(where: {$0.name == pathName})?.points.count ?? 0
            
            program.addPointToPath(pointName: point, for: pathName)
            
            let updatePath = dataSource.routes.first(where: {$0.name == pathName})
            
            #expect(updatePath?.points.contains(point) == true)
            #expect(updatePath?.points.count == initialCount + 1)
        }
        
        @Test func createUserThatFails(){
            let invalidUser = User(type: .normal, name: "Pericoeldelospalotes", email: "ejemplo@correocaliente.net", password: "12345")
            let invalidUser1 = User(type: .normal, name: "us", email: "ejemplocorrecto@correofrio.com", password: "123456")
            let initialCount = usersRegistration.count
            program.createUser(newUser: invalidUser)
            program.createUser(newUser: invalidUser1)
            let postCount = usersRegistration.count
            #expect(!usersRegistration.contains(invalidUser))
            #expect(!usersRegistration.contains(invalidUser1))
        }
        
        
        @Test func createUser(){
            let initialCount = usersRegistration.count
            print(usersRegistration)
            let userToBeAdded = User(type:.normal, name: "UsuarioNuevo", email: "usuarionuevo@keepcoding.es",password: "123456")
            program.createUser(newUser: userToBeAdded )
            print(usersRegistration)
            let afterCount = usersRegistration.count
            print(usersRegistration.count)
            #expect(afterCount == initialCount + 1 )
        }
        
        @Test func deleteUser() {
            program.createUser(newUser: User(type:.normal, name: "UsuarioNuevo", email: "usuarionuevo@keepcoding.es",password: "123456"))
            print(usersRegistration)
            program.deleteUser(userName: "UsuarioNuevo")
            print(usersRegistration)
            #expect(usersRegistration.count == 2)
        }
    }
}


//        @Suite class CreateUserTest{
//            
//            var program: Program
//            var logger: Logging
//            let dataSource = TopographicDataSource.shared
//            var users = usersRegistration
//            
//            init() {
//                logger = AppLogger(subsystem: "SnowTrails")
//                program = Program(logger: logger)
//            }
            
