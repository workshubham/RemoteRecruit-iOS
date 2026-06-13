//
//  SearchViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Testing
import Foundation
@testable import RemoteRecruit

@MainActor
struct SearchViewModelTests {

    @Test func startsIdle() {
        let vm = SearchViewModel(repository: MockJobRepository())
        #expect(vm.state == .idle)
        #expect(vm.results.isEmpty)
    }

    @Test func performSearchPopulatesResults() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { search, _, _ in
            #expect(search == "ios")
            return MockData.page([MockData.summary(id: "a"), MockData.summary(id: "b")])
        }
        let vm = SearchViewModel(repository: repo)

        await vm.performSearch("ios")

        #expect(vm.state == .results)
        #expect(vm.results.count == 2)
        #expect(repo.lastSearch == "ios")
    }

    @Test func noMatchesProducesEmptyState() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in MockData.page([]) }
        let vm = SearchViewModel(repository: repo)

        await vm.performSearch("zzz")

        #expect(vm.state == .empty)
    }

    @Test func emptyQueryResetsToIdle() {
        let vm = SearchViewModel(repository: MockJobRepository())
        vm.query = "   "
        vm.queryChanged()
        #expect(vm.state == .idle)
        #expect(vm.results.isEmpty)
    }

    @Test func failureProducesErrorState() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in throw RRNetworkError.serverError(500) }
        let vm = SearchViewModel(repository: repo)

        await vm.performSearch("ios")

        if case .error = vm.state {} else {
            Issue.record("Expected error state, got \(vm.state)")
        }
    }
}
