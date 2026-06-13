//
//  JobSummary.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

struct JobSummary: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let companyName: String
    let brandColorHex: String
    let location: String
    let workplaceType: WorkplaceType
    let employmentType: EmploymentType
    let level: ExperienceLevel
    let tags: [String]
    let salary: SalaryRange
    let postedAt: Date
}
