//
//  APIEnvironment.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

nonisolated struct APIEnvironment {
    let name: String
    let baseURL: URL

    /// Resolved at runtime from the active xcconfig (via Info.plist).
    static let current = APIEnvironment(
        name: Bundle.main.object(forInfoDictionaryKey: "API_ENVIRONMENT") as? String ?? "Unknown",
        baseURL: APIConstants.baseURL
    )
}
