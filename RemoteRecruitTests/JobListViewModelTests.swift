//
//  JobListViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Testing
import Foundation
@testable import RemoteRecruit

@MainActor
struct JobListViewModelTests {
    
    @Test func loadsFirstPageIntoLoadedState() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in
            MockData.page([MockData.summary(id: "a"), MockData.summary(id: "b")])
        }
        let vm = JobListViewModel(repository: repo)
        
        await vm.loadFirstPage()
        
        #expect(vm.state == .loaded)
        #expect(vm.jobs.count == 2)
    }
    
    @Test func emptyResultsProduceEmptyState() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in MockData.page([]) }
        let vm = JobListViewModel(repository: repo)
        
        await vm.loadFirstPage()
        
        #expect(vm.state == .empty)
        #expect(vm.jobs.isEmpty)
    }
    
    @Test func failureProducesErrorState() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in throw RRNetworkError.noConnection }
        let vm = JobListViewModel(repository: repo)
        
        await vm.loadFirstPage()
        
        if case .error(let message) = vm.state {
            #expect(message == RRNetworkError.noConnection.errorDescription)
        } else {
            Issue.record("Expected error state, got \(vm.state)")
        }
    }
    
    @Test func loadNextPageAppendsAndStopsAtLastPage() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, page in
            switch page {
                case 1: return MockData.page([MockData.summary(id: "a"), MockData.summary(id: "b")], page: 1, hasNextPage: true)
                default: return MockData.page([MockData.summary(id: "c")], page: 2, hasNextPage: false)
            }
        }
        let vm = JobListViewModel(repository: repo)
        
        await vm.loadFirstPage()
        #expect(vm.jobs.count == 2)
        
        await vm.loadNextPage()
        #expect(vm.jobs.map(\.id) == ["a", "b", "c"])
        
        // No more pages — another call is a no-op.
        let callsBefore = repo.jobsCallCount
        await vm.loadNextPage()
        #expect(repo.jobsCallCount == callsBefore)
    }
    
    @Test func sortIsForwardedToRepository() async {
        let repo = MockJobRepository()
        repo.jobsHandler = { _, _, _ in MockData.page([MockData.summary(id: "a")]) }
        let vm = JobListViewModel(repository: repo)
        vm.sort = .salaryHighToLow
        
        await vm.loadFirstPage()
        
        #expect(repo.lastSort == .salaryHighToLow)
    }
}
