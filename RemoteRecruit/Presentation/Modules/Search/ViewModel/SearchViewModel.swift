//
//  SearchViewModel.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {

    enum State: Equatable {
        case idle
        case loading
        case results
        case empty
        case error(String)
    }

    // MARK: - State

    private(set) var state: State = .idle
    private(set) var results: [JobSummary] = []

    var query: String = ""

    let suggestions = ["Remote", "Senior", "SwiftUI", "Fintech", "Contract"]

    // MARK: - Dependencies

    private let repository: JobRepository
    private var searchTask: Task<Void, Never>?

    init(repository: JobRepository = JobRepositoryImpl()) {
        self.repository = repository
    }

    func queryChanged() {
        searchTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .idle
            results = []
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await self?.performSearch(trimmed)
        }
    }

    func performSearch(_ term: String) async {
        state = .loading
        do {
            let page = try await repository.jobs(search: term, sort: .newest, page: 1)
            results = page.jobs
            state = page.jobs.isEmpty ? .empty : .results
        } catch {
            state = .error(message(for: error))
        }
    }

    private func message(for error: Error) -> String {
        (error as? RRNetworkError)?.errorDescription
            ?? "Something went wrong. Please try again."
    }
}
