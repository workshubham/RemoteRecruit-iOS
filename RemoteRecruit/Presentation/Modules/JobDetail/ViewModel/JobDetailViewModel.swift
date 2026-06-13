//
//  JobDetailViewModel.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class JobDetailViewModel {
    nonisolated deinit {}

    enum State: Equatable {
        case loading
        case loaded(Job)
        case error(String)
    }

    private(set) var state: State = .loading
    private(set) var isApplied = false

    private let jobID: String
    private let repository: JobRepository

    init(jobID: String, repository: JobRepository = JobRepositoryImpl()) {
        self.jobID = jobID
        self.repository = repository
    }

    func load() async {
        state = .loading
        do {
            let job = try await repository.job(id: jobID)
            state = .loaded(job)
        } catch {
            state = .error(message(for: error))
        }
    }

    func retry() async {
        await load()
    }

    func apply() {
        isApplied = true
    }

    private func message(for error: Error) -> String {
        (error as? RRNetworkError)?.errorDescription
            ?? "Something went wrong. Please try again."
    }
}
