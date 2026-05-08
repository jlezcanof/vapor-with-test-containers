//
//  RoomsWeb_TestContainers.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 29/04/2026.

import Testing
import TestContainers
import Foundation
import FluentPostgresDriver
//@testable import VaporWithTestContainers
//import Logging

//        LoggingSystem.bootstrap { label in
//            var handler = StreamLogHandler.standardOutput(label: label)
//            handler.logLevel = .trace
//            return handler
//        }

@Suite("TestContainers_proof",.serialized, .tags(.appleContainers))
struct AppleTestContainers {
        
//    private func makeDockerCLI() -> DockerClient {
//        let dockerPath = ProcessInfo.processInfo.environment["unix:///var/run/docker.sock"]//nunca obtiene este
//                ??  "/opt/homebrew/bin/docker"// usr/local/bin/docker
//            return DockerClient(dockerPath: dockerPath)
//    }
    
    @Test func proofRedis() async throws {

        let optedIn = ProcessInfo.processInfo.environment["TESTCONTAINERS_RUN_APPLE_CONTAINER_TESTS"] == "1"
        guard optedIn else {
            print("no existe esa variable de entorno")
            return
        }
        
        let dockerRuntime = detectRuntime(preferred: .docker)
                
        let request = ContainerRequest(image: "redis:7")
            .withExposedPort(6379)
            .waitingFor(.tcpPort(6379))
        
        try await withContainer(request, runtime: dockerRuntime) { container in
            let port = try await container.hostPort(6379)
            #expect(port > 0)
        }
        
        //        try await withContainer(request) { container in
        //            let port = try await container.hostPort(6379)
        //            #expect(port > 0)
        //        }
    }
    
}



