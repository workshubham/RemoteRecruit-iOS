//
//  JobPage.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

struct JobPage: Equatable {
    let jobs: [JobSummary]
    let page: Int
    let hasNextPage: Bool
}

enum JobSort: String, CaseIterable {
    case newest
    case salaryHighToLow = "salary_desc"
    case salaryLowToHigh = "salary_asc"
    
    var displayName: String {
        switch self {
            case .newest: return "Newest"
            case .salaryHighToLow: return "Salary: High to Low"
            case .salaryLowToHigh: return "Salary: Low to High"
        }
    }
}
