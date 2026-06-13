//
//  JobDetailViewModelTests.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Testing
import Foundation
@testable import RemoteRecruit

@MainActor
struct JobDetailViewModelTests {

    @Test func loadSuccessProducesLoadedState() async {
        let repo = MockJobRepository()
        repo.jobHandler = { id in MockData.job(id: id, title: "Staff iOS") }
        let vm = JobDetailViewModel(jobID: "rr-1", repository: repo)

        await vm.load()

        if case .loaded(let job) = vm.state {
            #expect(job.title == "Staff iOS")
        } else {
            Issue.record("Expected loaded, got \(vm.state)")
        }
    }

    @Test func loadFailureProducesErrorState() async {
        let repo = MockJobRepository()
        repo.jobHandler = { _ in throw RRNetworkError.notFound }
        let vm = JobDetailViewModel(jobID: "rr-1", repository: repo)

        await vm.load()

        if case .error = vm.state {} else {
            Issue.record("Expected error, got \(vm.state)")
        }
    }

    @Test func applyMarksJobApplied() {
        let vm = JobDetailViewModel(jobID: "rr-1", repository: MockJobRepository())

        #expect(vm.isApplied == false)
        vm.apply()
        #expect(vm.isApplied == true)
    }
}
