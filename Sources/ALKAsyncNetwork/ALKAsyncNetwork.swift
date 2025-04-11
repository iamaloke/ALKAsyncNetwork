// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case del = "DELETE"
}

public enum ALKNetworkError: Error {
    case configMissing
    case invalidResponse
    case badResponse(statusCode: Int, data: Data)
    case decoding(Error)
}

public protocol NetworkConfig {
    var urlCache: URLCache? { get }
    var session: URLSession { get }
}

public protocol Request {
    var method: RequestMethod { get }
    
    func make() -> URLRequest
}

public protocol ALKNetwork {}

public actor ALKNetworkManager: ALKNetwork {
    
    private var config: NetworkConfig?
    
    public init(config: NetworkConfig? = nil) {
        self.config = config
    }
    
    public func request<T: Decodable>(_ type: T.Type, request: Request) async throws -> T {
        guard let config = config else {
            throw ALKNetworkError.configMissing
        }
        
        let (data, response) = try await config
            .session
            .data(for: request.make())
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ALKNetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ALKNetworkError.badResponse(statusCode: httpResponse.statusCode, data: data)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ALKNetworkError.decoding(error)
        }
    }
    
}
