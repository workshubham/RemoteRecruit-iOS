//
//  JobEndpoint.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

enum JobEndpoint {

    static func list(search: String?, sort: JobSort, page: Int) -> APIRequest {
        var query: [String: String] = [
            "sort": sort.rawValue,
            "page": String(page),
        ]
        if let search, !search.isEmpty {
            query["search"] = search
        }
        return APIRequest(method: .get, path: "/api/jobs", queryParameters: query)
    }

    static func detail(id: String) -> APIRequest {
        APIRequest(method: .get, path: "/api/jobs/\(id)")
    }
}
