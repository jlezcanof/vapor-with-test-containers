//
//  AddHeaderHostToRequestMiddleware.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 05/05/2026.
//
import Vapor

final class AddHeaderHostToRequestMiddleware: AsyncMiddleware {
    
    func respond(to req: Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        req.headers.add(name: .host, value: "localhost")
        print("incluyendo cabecera host por cada peticion")
        return try await next.respond(to: req)
    }
}
