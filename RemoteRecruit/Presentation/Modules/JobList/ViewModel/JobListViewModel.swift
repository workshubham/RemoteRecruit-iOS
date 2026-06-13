//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class JobListViewModel {
    nonisolated deinit {}

    enum State: Equatable {
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - State
    private(set) var state: State = .loading
    private(set) var jobs: [JobSummary] = []
    private(set) var isLoadingNextPage = false

    var sort: JobSort = .newest {
        didSet {
            guard sort != oldValue else { return }
            Task { await loadFirstPage() }
        }
    }

    // MARK: - Dependencies
    private let repository: JobRepository
    private var currentPage = 1
    private var hasNextPage = false

    init(repository: JobRepository = JobRepositoryImpl()) {
        self.repository = repository
    }

    func onAppear() async {
        guard jobs.isEmpty, state != .empty else { return }
        await loadFirstPage()
    }

    func loadFirstPage() async {
        state = .loading
        currentPage = 1
        try? await Task.sleep(for: .seconds(2))
        do {
            let page = try await repository.jobs(search: nil, sort: sort, page: 1)
            jobs = page.jobs
            hasNextPage = page.hasNextPage
            state = page.jobs.isEmpty ? .empty : .loaded
        } catch {
            state = .error(message(for: error))
        }
    }

    func loadNextPage() async {
        guard hasNextPage, !isLoadingNextPage, state == .loaded else { return }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let next = currentPage + 1
            let page = try await repository.jobs(search: nil, sort: sort, page: next)
            jobs.append(contentsOf: page.jobs)
            currentPage = next
            hasNextPage = page.hasNextPage
        } catch {
            print("Failed to load next page")
        }
    }

    func retry() async {
        await loadFirstPage()
    }

    // MARK: - Helpers
    private func message(for error: Error) -> String {
        (error as? RRNetworkError)?.errorDescription
            ?? "Something went wrong. Please try again."
    }
}
