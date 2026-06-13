//
//  Job.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

enum EmploymentType: String, Decodable, Hashable {
    case fullTime = "full-time"
    case partTime = "part-time"
    case contract
    case internship
    
    var displayName: String {
        switch self {
            case .fullTime: return "Full-time"
            case .partTime: return "Part-time"
            case .contract: return "Contract"
            case .internship: return "Internship"
        }
    }
}

enum WorkplaceType: String, Decodable, Hashable {
    case remote
    case hybrid
    case onsite
    
    var displayName: String {
        switch self {
            case .remote: return "Remote"
            case .hybrid: return "Hybrid"
            case .onsite: return "On-site"
        }
    }
}

enum ExperienceLevel: String, Decodable, Hashable {
    case junior
    case mid
    case senior
    case staff
    case lead
    
    var displayName: String {
        switch self {
            case .junior: return "Junior"
            case .mid: return "Mid"
            case .senior: return "Senior"
            case .staff: return "Staff"
            case .lead: return "Lead"
        }
    }
}

enum SalaryPeriod: String, Decodable, Hashable {
    case year
    case month
    case hour
    
    var shortName: String {
        switch self {
            case .year: return "yr"
            case .month: return "mo"
            case .hour: return "hr"
        }
    }
}

struct SalaryRange: Equatable, Hashable {
    let min: Int
    let max: Int
    let currency: String
    let period: SalaryPeriod
}

struct Company: Equatable, Hashable {
    let name: String
    let about: String
    let industry: String
    let size: String
    let founded: Int
    let brandColorHex: String
    let website: URL?
}

/// Full job detail, shown on the detail screen.
struct Job: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let company: Company
    let location: String
    let workplaceType: WorkplaceType
    let employmentType: EmploymentType
    let level: ExperienceLevel
    let tags: [String]
    let salary: SalaryRange
    let description: String
    let responsibilities: [String]
    let postedAt: Date
}
