//
//  RRNetworkError.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

enum RRNetworkError: Error, Equatable {
    case invalidURL
    case notFound
    case badRequest(message: String?)
    case serverError(Int)
    case decodingFailed
    case noConnection
    case unknown
    
    static func == (lhs: RRNetworkError, rhs: RRNetworkError) -> Bool {
        switch (lhs, rhs) {
            case (.invalidURL, .invalidURL),
                (.notFound, .notFound),
                (.decodingFailed, .decodingFailed),
                (.noConnection, .noConnection),
                (.unknown, .unknown):
                return true
            case let (.badRequest(a), .badRequest(b)):
                return a == b
            case let (.serverError(a), .serverError(b)):
                return a == b
            default:
                return false
        }
    }
}

extension RRNetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "We couldn't reach the server."
            case .notFound:
                return "We couldn't find what you were looking for."
            case .badRequest(let message):
                return message ?? "That request couldn't be processed."
            case .serverError(let code):
                return "Server error (\(code)). Please try again."
            case .decodingFailed:
                return "We received an unexpected response from the server."
            case .noConnection:
                return "You're offline. Check your connection and try again."
            case .unknown:
                return "Something went wrong. Please try again."
        }
    }
}
