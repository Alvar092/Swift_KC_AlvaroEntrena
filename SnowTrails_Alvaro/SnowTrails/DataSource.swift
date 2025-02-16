//
//  DataSource.swift
//  SnowTrails
//
//  Created by Álvaro Entrena Casas on 7/2/25.
//

import Foundation

class TopographicDataSource{
    
    //Variable de acceso global al DataSource
    static let shared = TopographicDataSource()
    
    //Impide la creación de varias instancias. 
    private init() {
        self.topographicPoints = initTopographicPoints()
        self.routes = initRoutes()
        self.pointConnections = initPointConnections()
    }
    
    var topographicPoints : [TopographicPoint]
    var routes: [Path]
    var pointConnections: [String: [String]]
}


struct TopographicPoint{
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double
    var connections: [String]
}

func initPointConnections() -> [String: [String]] {
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
    return pointConnections
}


func initTopographicPoints() -> [TopographicPoint]{
    
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
    

    let topographicPoints: [TopographicPoint] = [
        TopographicPoint(name: "Alpina Grande", latitude: 46.0000, longitude: 7.5000, elevation: 1500.0, connections: pointConnections["Alpina Grande"] ?? []),
        TopographicPoint(name: "Alpina Pequeña", latitude: 46.0022, longitude: 7.5200, elevation: 1200.0, connections: pointConnections["Alpina Pequeña"] ?? [] ),
        TopographicPoint(name: "Pico Nevado", latitude: 46.1000, longitude: 7.6000, elevation: 1600.0, connections: pointConnections["Pico Nevado"] ?? [] ),
        TopographicPoint(name: "Valle Blanco", latitude: 45.9000, longitude: 7.4000, elevation: 1400.0, connections: pointConnections["Valle Blanco"] ?? [] ),
        TopographicPoint(name: "Cumbre Azul", latitude: 46.0500, longitude: 7.5500, elevation: 1550.0, connections: pointConnections["Cumbre Azul"] ?? [] ),
        TopographicPoint(name: "Lago Helado", latitude: 46.2000, longitude: 7.7000, elevation: 1700.0, connections: pointConnections["Lago Helado"] ?? [] ),
        TopographicPoint(name: "Bosque Nevado", latitude: 46.3000, longitude: 7.8000, elevation: 1800.0, connections: pointConnections["Bosque Nevado"] ?? []),
        TopographicPoint(name: "Cerro Plateado", latitude: 46.1500, longitude: 7.6500, elevation: 1650.0, connections: pointConnections["Cerro Plateado"] ?? []),
        TopographicPoint(name: "Cascada Blanca", latitude: 46.2500, longitude: 7.7500, elevation: 1750.0, connections: pointConnections["Cascada Blanca"] ?? []),
        TopographicPoint(name: "Refugio Alpino", latitude: 46.0500, longitude: 7.4500, elevation: 1450.0, connections: pointConnections["Refugio Alpino"] ?? []),
        TopographicPoint(name: "Refugio Aislado", latitude: 46.0000, longitude: 7.4000, elevation: 1400.0, connections: pointConnections["Refugio Aislado"] ?? [])
    ]
    
    
    return topographicPoints
}
    
    struct Path {
        let name: String
        var points: [String]
    }
    
func initRoutes() -> [Path] {
    return [
        Path(name: "Ruta del Pico Nevado y Lago Helado", points: ["Alpina Grande", "Pico Nevado", "Lago Helado"]),
        Path(name: "Ruta del Valle Blanco y Refugio Alpino", points: ["Alpina Grande", "Valle Blanco", "Refugio Alpino"]),
        Path(name: "Ruta de la Cumbre Azul y Cerro Plateado", points: ["Alpina Grande", "Cumbre Azul", "Cerro Plateado"]),
        Path(name: "Ruta del Bosque Nevado y Cascada Blanca", points: ["Lago Helado", "Bosque Nevado", "Cascada Blanca"]),
        Path(name: "Ruta completa de Alpina Grande a Cascada Blanca", points: ["Alpina Grande", "Pico Nevado", "Lago Helado", "Bosque Nevado", "Cascada Blanca"]),
        Path(name: "Ruta del Refugio Aislado", points: ["Refugio Aislado"]),
        Path(name: "Ruta Alpina", points: ["Alpina Grande", "Alpina Pequeña"])
    ]
}

    
