//
//  HTTPClient.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

/// Network transport abstraction. Repositories depend on this rather than on
/// URLSession directly, so they can be tested against a stub client.
protocol HTTPClient: Sendable {
    func send<T: Decodable>(_ request: APIRequest) async throws -> T
}
