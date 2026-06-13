//
//  MockJobRepository.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation
@testable import RemoteRecruit

final class MockJobRepository: JobRepository, @unchecked Sendable {

    var jobsHandler: (@Sendable (String?, JobSort, Int) throws -> JobPage)?
    var jobHandler: (@Sendable (String) throws -> Job)?

    private(set) var lastSearch: String?
    private(set) var lastSort: JobSort?
    private(set) var lastPage: Int?
    private(set) var jobsCallCount = 0

    func jobs(search: String?, sort: JobSort, page: Int) async throws -> JobPage {
        lastSearch = search
        lastSort = sort
        lastPage = page
        jobsCallCount += 1
        if let jobsHandler {
            return try jobsHandler(search, sort, page)
        }
        return JobPage(jobs: [], page: page, hasNextPage: false)
    }

    func job(id: String) async throws -> Job {
        if let jobHandler {
            return try jobHandler(id)
        }
        return MockData.job(id: id)
    }
}
