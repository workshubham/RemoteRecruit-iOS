//
//  JobDTOs.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import Foundation

// MARK: - Shared

struct SalaryRangeDTO: Decodable {
    let min: Int
    let max: Int
    let currency: String
    let period: String
}

// MARK: - List

struct JobListResponseDTO: Decodable {
    let data: [JobSummaryDTO]
    let pagination: PaginationDTO
}

struct PaginationDTO: Decodable {
    let page: Int
    let hasNextPage: Bool
}

struct JobSummaryDTO: Decodable {
    let id: String
    let title: String
    let companyName: String
    let brandColor: String
    let location: String
    let workplaceType: String
    let employmentType: String
    let level: String
    let tags: [String]
    let salary: SalaryRangeDTO
    let postedAt: Date
}

// MARK: - Detail

struct JobDetailResponseDTO: Decodable {
    let data: JobDTO
}

struct CompanyDTO: Decodable {
    let name: String
    let about: String
    let industry: String
    let size: String
    let founded: Int
    let brandColor: String
    let website: String?
}

struct JobDTO: Decodable {
    let id: String
    let title: String
    let company: CompanyDTO
    let location: String
    let workplaceType: String
    let employmentType: String
    let level: String
    let tags: [String]
    let salary: SalaryRangeDTO
    let description: String
    let responsibilities: [String]
    let postedAt: Date
}

// MARK: - Mapping to Domain

extension SalaryRangeDTO {
    func toDomain() -> SalaryRange {
        SalaryRange(
            min: min,
            max: max,
            currency: currency,
            period: SalaryPeriod(rawValue: period) ?? .year
        )
    }
}

extension JobSummaryDTO {
    func toDomain() -> JobSummary {
        JobSummary(
            id: id,
            title: title,
            companyName: companyName,
            brandColorHex: brandColor,
            location: location,
            workplaceType: WorkplaceType(rawValue: workplaceType) ?? .remote,
            employmentType: EmploymentType(rawValue: employmentType) ?? .fullTime,
            level: ExperienceLevel(rawValue: level) ?? .mid,
            tags: tags,
            salary: salary.toDomain(),
            postedAt: postedAt
        )
    }
}

extension CompanyDTO {
    func toDomain() -> Company {
        Company(
            name: name,
            about: about,
            industry: industry,
            size: size,
            founded: founded,
            brandColorHex: brandColor,
            website: website.flatMap(URL.init(string:))
        )
    }
}

extension JobDTO {
    func toDomain() -> Job {
        Job(
            id: id,
            title: title,
            company: company.toDomain(),
            location: location,
            workplaceType: WorkplaceType(rawValue: workplaceType) ?? .remote,
            employmentType: EmploymentType(rawValue: employmentType) ?? .fullTime,
            level: ExperienceLevel(rawValue: level) ?? .mid,
            tags: tags,
            salary: salary.toDomain(),
            description: description,
            responsibilities: responsibilities,
            postedAt: postedAt
        )
    }
}
