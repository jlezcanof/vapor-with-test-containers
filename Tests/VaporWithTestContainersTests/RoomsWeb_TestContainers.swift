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
    
    @Test("Redis Example")
    func redisExample() async throws {
        
        let dockerClient = makeDockerCLI()
        
        //  let runtime = AppleContainerClient()
        
        let dockerRuntime = detectRuntime(preferred: .docker)
        if await dockerRuntime.isAvailable() {
            print("docker runtime is available")
        } else {
            print("docker runtime is not available")
        }
        
        let appleContainer = detectRuntime(preferred: .appleContainer)
        if await appleContainer.isAvailable() {
            print("apple container is available")
        } else {
            print("apple container is not available")
        }
        
        let containerRequest = ContainerRequest(image: "redis:alpine")// redis:7
            .withExposedPort(6379)
            .waitingFor(.tcpPort(6379))
                
        let idContainer = try await dockerClient.createContainer(containerRequest)
        print("idContainer is \(idContainer)")
        
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

    @Test("sql postgres")
    func testContainerSqlPostgres() async throws {
        
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
            
//            let startDatabase = """
//                pg_ctl -D /var/lib/postgresql/data -l logfile start
//            """
            
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
            
            let resultado = try await operation.exec([/*startDatabase,*/ createTable, insertTable])
            
            let logs = try await operation.logs()
            print("logs is \(logs)")
            
            print("resultado is \(resultado)")
            
//            #expect(resultado.stdout.contains("OCI runtime exec failed:")) //  > 0

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
    

    // kafka
//    @Test func kafkaExample() async throws {
//        let kafka = KafkaContainer()
//
//        try await withContainer(kafka.build()) { container in
//            let bootstrapServers = try await KafkaContainer.bootstrapServers(from: container)
//            #expect(bootstrapServers.contains(":"))
//        }
//    }
    
    // Elastic Search
//    @Test func elasticsearchExample() async throws {
//        let elasticsearch = ElasticsearchContainer()
//            .withSecurityDisabled()
//
//        try await withElasticsearchContainer(elasticsearch) { container in
//            let address = try await container.httpAddress()
//            #expect(address.hasPrefix("http://"))
//        }
//    }
    
//    @Test func openSearchExample() async throws {
//        let openSearch = OpenSearchContainer()
//            .withSecurityDisabled()
//
//        try await withOpenSearchContainer(openSearch) { container in
//            let settings = try await container.settings()
//            #expect(settings.address.hasPrefix("http://"))
//        }
//    }
    
    // Container runtimes
    // Explicit runtime selection
//    let runtime = AppleContainerClient()
//    try await withContainer(request, runtime: runtime) { container in ... }
//
//    // Or use detectRuntime() with environment variable
//    // TESTCONTAINERS_RUNTIME=apple swift test
//    let runtime = detectRuntime()
//    try await withContainer(request, runtime: runtime) { container in ... }
}



