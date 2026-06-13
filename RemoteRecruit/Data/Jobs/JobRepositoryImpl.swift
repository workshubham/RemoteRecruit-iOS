//
//  JobRepositoryImpl.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

final class JobRepositoryImpl: JobRepository {

    private let http: HTTPClient

    init(http: HTTPClient = URLSessionHTTPClient.shared) {
        self.http = http
    }

    func jobs(search: String?, sort: JobSort, page: Int) async throws -> JobPage {
        let request = JobEndpoint.list(search: search, sort: sort, page: page)
        let response: JobListResponseDTO = try await http.send(request)
        return JobPage(
            jobs: response.data.map { $0.toDomain() },
            page: response.pagination.page,
            hasNextPage: response.pagination.hasNextPage
        )
    }

    func job(id: String) async throws -> Job {
        let request = JobEndpoint.detail(id: id)
        let response: JobDetailResponseDTO = try await http.send(request)
        return response.data.toDomain()
    }
}
