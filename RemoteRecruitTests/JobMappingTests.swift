//
//  JobMappingTests.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Testing
import Foundation
@testable import RemoteRecruit

struct JobMappingTests {

    @Test func summaryDTOMapsToDomain() {
        let dto = JobSummaryDTO(
            id: "rr-1",
            title: "iOS Engineer",
            companyName: "Lumen Health",
            brandColor: "#6EB5E3",
            location: "Remote · US",
            workplaceType: "remote",
            employmentType: "full-time",
            level: "senior",
            tags: ["Swift", "SwiftUI"],
            salary: SalaryRangeDTO(min: 165_000, max: 200_000, currency: "USD", period: "year"),
            postedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let summary = dto.toDomain()

        #expect(summary.id == "rr-1")
        #expect(summary.companyName == "Lumen Health")
        #expect(summary.brandColorHex == "#6EB5E3")
        #expect(summary.workplaceType == .remote)
        #expect(summary.employmentType == .fullTime)
        #expect(summary.level == .senior)
        #expect(summary.tags == ["Swift", "SwiftUI"])
        #expect(summary.salary.min == 165_000)
    }

    @Test func unknownEnumValuesFallBackToDefaults() {
        let dto = JobSummaryDTO(
            id: "x", title: "T", companyName: "C", brandColor: "#000000",
            location: "L", workplaceType: "spaceship", employmentType: "freelance",
            level: "wizard", tags: [],
            salary: SalaryRangeDTO(min: 1, max: 2, currency: "USD", period: "decade"),
            postedAt: Date()
        )

        let summary = dto.toDomain()

        #expect(summary.workplaceType == .remote)   // default
        #expect(summary.employmentType == .fullTime) // default
        #expect(summary.level == .mid)               // default
        #expect(summary.salary.period == .year)      // default
    }

    @Test func jobDTOMapsCompanyAndResponsibilities() {
        let dto = JobDTO(
            id: "rr-2",
            title: "Staff iOS",
            company: CompanyDTO(
                name: "Cardinal", about: "Trading tools.", industry: "Fintech",
                size: "1,000–5,000", founded: 2009, brandColor: "#FF3B30",
                website: "https://example.com/cardinal"
            ),
            location: "On-site · New York",
            workplaceType: "onsite",
            employmentType: "full-time",
            level: "staff",
            tags: ["Swift"],
            salary: SalaryRangeDTO(min: 220_000, max: 265_000, currency: "USD", period: "year"),
            description: "Lead.",
            responsibilities: ["Own architecture", "Mentor"],
            postedAt: Date()
        )

        let job = dto.toDomain()

        #expect(job.company.name == "Cardinal")
        #expect(job.company.founded == 2009)
        #expect(job.company.website?.absoluteString == "https://example.com/cardinal")
        #expect(job.workplaceType == .onsite)
        #expect(job.level == .staff)
        #expect(job.responsibilities.count == 2)
    }
}
