//
//  TestsProofContainersScope.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 06/05/2026.
//
import Testing
import Vapor

struct ProofContainersScope: SuiteTrait, TestScoping {
    
    @TaskLocal static var app: Application!
    
    func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        
        let app = try await TestAppContainers.make()
        
        app.middleware.use(AddHeaderHostToRequestMiddleware())
        
        try await function()
        
        try await TestAppContainers.shutdown(app)
    }
 
}

extension Trait where Self == ProofContainersScope {
    static var proofContainersScope: Self { Self() }
}

struct TestAppContainers {
    
    static func make () async throws -> Application {
        
        // Un único EventLoop (opcional, pero recomendable en tests)
        let elg = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let app = try await Application.make(.testing, .shared(elg))
        
        return app
    }
    
    static func shutdown(_ app: Application) async throws {
        try await app.asyncShutdown()
        //try? FileManager.defaulta.removeItem(at: url)
    }
}
