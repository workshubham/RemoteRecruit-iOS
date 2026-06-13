//
//  APIRequest.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

/// Describes one HTTP request independent of how it's sent. Endpoints build
/// these; the HTTPClient turns them into a URLRequest.
struct APIRequest {
    let method: HTTPMethod
    let path: String
    let queryParameters: [String: String]

    init(method: HTTPMethod, path: String, queryParameters: [String: String] = [:]) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
    }
}
