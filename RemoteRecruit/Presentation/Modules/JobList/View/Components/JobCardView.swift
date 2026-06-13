//
//  JobCardView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct JobCardView: View {
    let job: JobSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(alignment: .top, spacing: 13) {
                CompanyLogoView(companyName: job.companyName, brandColorHex: job.brandColorHex)

                VStack(alignment: .leading, spacing: 3) {
                    Text(job.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(.textPrimary))
                        .lineLimit(2)
                    Text(job.companyName)
                        .font(.system(size: 14.5))
                        .foregroundStyle(Color(.textSecondary))
                }

                Spacer(minLength: 8)

                Text(job.postedAt.timeAgo)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color(.textTertiary))
            }

            HStack(spacing: 6) {
                Label {
                    Text(job.location)
                } icon: {
                    Image(systemName: "mappin.and.ellipse")
                }
                .labelStyle(.titleAndIcon)
                .font(.system(size: 13))
                .foregroundStyle(Color(.textSecondary))

                RRChip(job.workplaceType.displayName)
                RRChip(job.employmentType.displayName)
            }
            .padding(.top, 13)

            Rectangle()
                .fill(Color(.separatorLine))
                .frame(height: 1)
                .padding(.vertical, 13)

            HStack {
                Text(job.salary.formatted)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.accentText))
                Spacer()
                RRChip(job.level.displayName, tone: .accent)
            }
        }
        .padding(16)
        .background(Color(.surface), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }
}

#Preview {
    JobCardView(
        job: JobSummary(
            id: "rr-1024",
            title: "Senior iOS Engineer",
            companyName: "Lumen Health",
            brandColorHex: "#6EB5E3",
            location: "Remote · US",
            workplaceType: .remote,
            employmentType: .fullTime,
            level: .senior,
            tags: ["Swift", "SwiftUI"],
            salary: SalaryRange(min: 165_000, max: 200_000, currency: "USD", period: .year),
            postedAt: Date().addingTimeInterval(-4 * 3600)
        )
    )
    .padding()
    .background(Color(.background))
}
