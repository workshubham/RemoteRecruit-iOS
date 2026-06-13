//
//  MockData.swift
//  RemoteRecruitTests
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation
@testable import RemoteRecruit

enum MockData {
    static func summary(
        id: String,
        title: String = "iOS Engineer",
        company: String = "Acme",
        salaryMin: Int = 100_000,
        salaryMax: Int = 150_000
    ) -> JobSummary {
        JobSummary(
            id: id,
            title: title,
            companyName: company,
            brandColorHex: "#6EB5E3",
            location: "Remote · US",
            workplaceType: .remote,
            employmentType: .fullTime,
            level: .senior,
            tags: ["Swift"],
            salary: SalaryRange(min: salaryMin, max: salaryMax, currency: "USD", period: .year),
            postedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )
    }

    static func job(id: String = "rr-1", title: String = "iOS Engineer") -> Job {
        Job(
            id: id,
            title: title,
            company: Company(
                name: "Acme",
                about: "We build things.",
                industry: "Tech",
                size: "51–200",
                founded: 2018,
                brandColorHex: "#6EB5E3",
                website: URL(string: "https://example.com")
            ),
            location: "Remote · US",
            workplaceType: .remote,
            employmentType: .fullTime,
            level: .senior,
            tags: ["Swift", "SwiftUI"],
            salary: SalaryRange(min: 150_000, max: 200_000, currency: "USD", period: .year),
            description: "Para one.\n\nPara two.",
            responsibilities: ["Ship features", "Write tests"],
            postedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )
    }

    static func page(_ summaries: [JobSummary], page: Int = 1, hasNextPage: Bool = false) -> JobPage {
        JobPage(jobs: summaries, page: page, hasNextPage: hasNextPage)
    }
}
