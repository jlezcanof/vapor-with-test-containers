//
//  RoomsWeb_TestContainers.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 29/04/2026.

import Testing
import TestContainers
import Foundation

@Suite("RoomsWeb_TestContainers", .serialized, .tags(.testContainers))
struct RoomsWeb_TestContainers {
    
    private func makeDockerClient() -> DockerClient {
        if let host = ProcessInfo.processInfo.environment["unix:///Users/lezcanin/.docker/run/docker.sock"],// DOCKER_HOST
           host.hasPrefix("unix://"){
            let socketPath = String(host.dropFirst("unix://".count))
            return DockerClient(socketPath: socketPath)
        }
        return DockerClient()
    }
    
    @Test
    func redisExample() async throws {
        
        let runtime = DockerClient(socketPath: "/Users/lezcanin/.docker/run/docker.sock")
        
        
        let request = ContainerRequest(image: "redis:7")
            .withExposedPort(6379)
            .waitingFor(.tcpPort(6379))
        
        let resultado = try await runtime.createContainer(request)
        print("resultado is \(resultado)")

        try await withContainer(request) { container in
            let port = try await container.hostPort(6379)
            #expect(port > 0)
        }
    }
//
//    @Test
//    func testPrueba() {
//        let request = ContainerRequest(image: "redis:7")
//            .withExposedPort(6379) // random host port
//            .waitingFor(.tcpPort(6379))
//    }

//    @Test
//    func testprueba1() {
//        // 1. Arrancar el contenedor de PostgreSQL
//        let request = ContainerRequest(image: "postgres:17")
//            .withExposedPort(5432)
//            .withEnvironment([
//                "POSTGRES_DB": "testDB",
//                "POSTGRES_USER": "testUser",
//                "POSTGRES_PASSWORD": "testPassword"
//            ])
//            .waitingFor(.tcpPort(5432))
//
//        try await withContainer(request) { container in
//            let port = try await container.hostPort(5432)
//
//            // 2. Conectar con PostgresNIO o tu cliente habitual
//            let config = SQLPostgresConfiguration(
//                hostname: "localhost",
//                port: port,
//                username: "testUser",
//                password: "testPassword",
//                database: "testDB",
//                tls: .disable
//            )
//
//            // 3. Crear tablas y popular datos aquí dentro
//            try await db.run("""
//                CREATE TABLE users (
//                    id SERIAL PRIMARY KEY,
//                    name TEXT NOT NULL,
//                    email TEXT UNIQUE NOT NULL
//                )
//            """)
//
//            try await db.run("""
//                INSERT INTO users (name, email)
//                VALUES ('John Doe', 'john@example.com'),
//                       ('Jane Doe', 'jane@example.com')
//            """)
//
//            // 4. Ejecutar tus tests
//        }
//        // El contenedor se destruye automáticamente al salir del bloque
//
//
//    }
    

}



