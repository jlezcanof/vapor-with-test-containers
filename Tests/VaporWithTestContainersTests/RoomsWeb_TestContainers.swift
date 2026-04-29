//
//  RoomsWeb_TestContainers.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 29/04/2026.

import Testing
import TestContainers
import Foundation
import FluentPostgresDriver

@Suite("RoomsWeb_TestContainers", .serialized, .tags(.testContainers))
struct RoomsWeb_TestContainers {
        
    private func makeDockerCLI() -> DockerClient {
        let dockerPath = ProcessInfo.processInfo.environment["Users/lezcanin/.docker/run/docker.sock"]//nunca obtiene este
                ?? "/usr/local/bin/docker"
            return DockerClient(dockerPath: dockerPath)
    }
    
    @Test
    func redisExample() async throws {
        
        let dockerClient = makeDockerCLI()
        
        let containerRequest = ContainerRequest(image: "redis:alpine")// redis:7
            .withExposedPort(6379)
            .waitingFor(.tcpPort(6379))
                
        let idContainer = try await dockerClient.createContainer(containerRequest)
        print("resultado is \(idContainer)")
        
        try await withContainer(containerRequest, runtime: dockerClient) { container in
            let logs = try await container.logs()
            print("\(logs)")
            let port = try await container.hostPort(6379)
            print("port is \(port)")
            #expect(port > 0)
        }

        try await dockerClient.removeImage(idContainer)
        try await dockerClient.removeContainer(id: idContainer)
    }

    @Test
    func testContainerSqlPostgress() async throws{
        
        let dockerClient = makeDockerCLI()
        
        // 1. Arrancar el contenedor de PostgreSQL
        let request = ContainerRequest(image: "postgres:16")//17
            .withExposedPort(5432)
            .withEnvironment([
                "POSTGRES_DB": "egymDB",
                "POSTGRES_USER": "gymUser",
                "POSTGRES_PASSWORD": "NADGzUX+C4JhE35vRZ2sgLXDtSt5K7X9nxxyMUOaJt8="
            ])
            .waitingFor(.tcpPort(5432))
        
        let idContainer = try await dockerClient.createContainer(request)
        
        // 2. Conectar con PostgresNIO o tu cliente habitual
//        let config = SQLPostgresConfiguration(hostname: "localhost",
//                                                  port: 5432,
//                                                  username: "gymUser",
//                                                  password: "NADGzUX+C4JhE35vRZ2sgLXDtSt5K7X9nxxyMUOaJt8=",
//                                                  database: "egymDB",
//                                                  tls: .disable)
        
    
        let config = PostgresContainer(image: request.image)
        
        try await withPostgresContainer(config,
                              runtime: dockerClient) { operation in
            
            let createTable = """
                CREATE TABLE users (
                    id SERIAL PRIMARY KEY,
                    name TEXT NOT NULL,                   
            """
            
            let insertTable = """
            INSERT INTO users (name, email)
                        VALUES ('John Doe', 'john@example.com'),
                               ('Jane Doe', 'jane@example.com')
            """
            
            let resultado = try await operation.exec([createTable, insertTable])
            
            print("resultado is \(resultado)")
        }
//        
//        try await withContainer(request, runtime: dockerClient) { container in
//            let port = try await container.hostPort(5432)
//            
            // 2. Conectar con PostgresNIO o tu cliente habitual
//            let config = SQLPostgresConfiguration(hostname: "localhost",
//                                                  port: 5432,
//                                                  username: "gymUser",
//                                                  password: "NADGzUX+C4JhE35vRZ2sgLXDtSt5K7X9nxxyMUOaJt8=",
//                                                  database: "egymDB",
//                                                  tls: .disable)
            
//            let createTable = """
//                CREATE TABLE users (
//                    id SERIAL PRIMARY KEY,
//                    name TEXT NOT NULL,                   
//            """
//            
//            container.exec([createTable])
            
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

            // 4. Ejecutar tus tests
//        }
        
        
        // El contenedor se destruye automáticamente al salir del bloque
        try await dockerClient.removeImage(idContainer)
        try await dockerClient.removeContainer(id: idContainer)
    }
    

}



