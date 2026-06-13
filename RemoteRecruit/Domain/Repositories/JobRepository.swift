//
//  JobRepository.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

protocol JobRepository: Sendable {

    func jobs(search: String?, sort: JobSort, page: Int) async throws -> JobPage
    func job(id: String) async throws -> Job
}
