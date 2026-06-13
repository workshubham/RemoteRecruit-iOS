//
//  URLSessionHTTPClient.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

nonisolated final class URLSessionHTTPClient: HTTPClient {
    
    static let shared = URLSessionHTTPClient()
    
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        environment: APIEnvironment = .current,
        session: URLSession = .shared
    ) {
        self.baseURL = environment.baseURL
        self.session = session
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            guard let date = ISO8601DateParser.date(from: string) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unrecognized date: \(string)"
                )
            }
            return date
        }
        self.decoder = decoder
    }
    
    func send<T: Decodable>(_ request: APIRequest) async throws -> T {
        let urlRequest = try buildURLRequest(from: request)
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw RRNetworkError.noConnection
        } catch {
            throw RRNetworkError.unknown
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw RRNetworkError.unknown
        }
        
        switch http.statusCode {
            case 200..<300:
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw RRNetworkError.decodingFailed
                }
            case 400:
                throw RRNetworkError.badRequest(message: decodeErrorMessage(from: data))
            case 404:
                throw RRNetworkError.notFound
            case 500...:
                throw RRNetworkError.serverError(http.statusCode)
            default:
                throw RRNetworkError.unknown
        }
    }
    
    // MARK: - Private
    private func buildURLRequest(from request: APIRequest) throws -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: false
        )
        if !request.queryParameters.isEmpty {
            components?.queryItems = request.queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let url = components?.url else {
            throw RRNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
    
    private func decodeErrorMessage(from data: Data) -> String? {
        struct ErrorEnvelope: Decodable {
            struct Body: Decodable { let message: String? }
            let error: Body?
        }
        return try? JSONDecoder().decode(ErrorEnvelope.self, from: data).error?.message
    }
}
