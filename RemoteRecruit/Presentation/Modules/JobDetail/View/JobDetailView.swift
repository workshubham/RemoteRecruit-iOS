//
//  JobDetailView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct JobDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: JobDetailViewModel
    
    init(jobID: String) {
        _viewModel = State(wrappedValue: JobDetailViewModel(jobID: jobID))
    }
    
    var body: some View {
        content
            .background(Color(.background))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .task { await viewModel.load() }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.background))
            case .error(let message):
                StatusView(
                    icon: "wifi.slash",
                    iconColor: .orange,
                    title: "Couldn't load this job",
                    message: message,
                    actionTitle: "Try Again",
                    action: { Task { await viewModel.retry() } }
                )
            case .loaded(let job):
                loaded(job)
        }
    }
    
    private func loaded(_ job: Job) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CompanyLogoView(companyName: job.company.name, brandColorHex: job.company.brandColorHex, size: 70, radius: 20)
                
                Text(job.title)
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(Color(.textPrimary))
                    .padding(.top, 16)
                
                HStack(spacing: 7) {
                    Text(job.company.name)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.textPrimary))
                    Text("·").foregroundStyle(Color(.textTertiary))
                    Label(job.location, systemImage: "mappin.and.ellipse")
                        .foregroundStyle(Color(.textSecondary))
                }
                .font(.system(size: 16))
                .padding(.top, 9)
                
                chips(job)
                    .padding(.top, 13)
                
                salaryCard(job)
                    .padding(.top, 18)
                
                sectionTitle("About the role")
                ForEach(Array(job.description.components(separatedBy: "\n\n").enumerated()), id: \.offset) { _, para in
                    Text(para)
                        .font(.system(size: 15.5))
                        .foregroundStyle(Color(.textSecondary))
                        .lineSpacing(3)
                        .padding(.top, 4)
                }
                
                sectionTitle("What you'll do")
                VStack(alignment: .leading, spacing: 11) {
                    ForEach(job.responsibilities, id: \.self) { item in
                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(Color(.accentSoft))
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Color(.accentText))
                                )
                            Text(item)
                                .font(.system(size: 15.5))
                                .foregroundStyle(Color(.textSecondary))
                        }
                    }
                }
                
                if !job.tags.isEmpty {
                    sectionTitle("Skills")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 7) {
                            ForEach(job.tags, id: \.self) { RRChip($0) }
                        }
                    }
                }
                
                sectionTitle("Company")
                companyCard(job)
                    .padding(.bottom, 8)
            }
            .padding(20)
        }
        .background(Color(.background))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareText(job)) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            applyBar(job)
        }
    }
    
    // MARK: - Pieces
    
    private func chips(_ job: Job) -> some View {
        HStack(spacing: 7) {
            RRChip(job.workplaceType.displayName)
            RRChip(job.employmentType.displayName)
            RRChip(job.level.displayName, tone: .accent)
            RRChip(job.postedAt.timeAgo, systemImage: "clock")
        }
    }
    
    private func salaryCard(_ job: Job) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("SALARY RANGE")
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundStyle(Color(.accentText))
                Text(job.salary.formatted)
                    .font(.system(size: 23, weight: .heavy))
                    .foregroundStyle(Color(.textPrimary))
            }
            Spacer()
            Image(systemName: "banknote")
                .font(.system(size: 28))
                .foregroundStyle(Color(.accentText))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color(.accentSoft), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private func companyCard(_ job: Job) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 12) {
                CompanyLogoView(companyName: job.company.name, brandColorHex: job.company.brandColorHex, size: 44, radius: 13)
                VStack(alignment: .leading, spacing: 1) {
                    Text(job.company.name)
                        .font(.system(size: 16.5, weight: .bold))
                        .foregroundStyle(Color(.textPrimary))
                    Text(job.company.industry)
                        .font(.system(size: 13.5))
                        .foregroundStyle(Color(.textSecondary))
                }
            }
            Text(job.company.about)
                .font(.system(size: 15))
                .foregroundStyle(Color(.textSecondary))
                .lineSpacing(2)
            HStack(spacing: 8) {
                stat("person.2", "Size", job.company.size)
                stat("building.2", "Industry", job.company.industry)
                stat("calendar", "Founded", String(job.company.founded))
            }
        }
        .padding(18)
        .background(Color(.surface), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }
    
    private func stat(_ icon: String, _ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(label, systemImage: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color(.textSecondary))
                .labelStyle(.titleAndIcon)
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func applyBar(_ job: Job) -> some View {
        let applied = viewModel.isApplied
        return Button {
            guard !applied else { return }
            viewModel.apply()
            Task {
                try? await Task.sleep(for: .milliseconds(650))
                dismiss()
            }
        } label: {
            HStack(spacing: 8) {
                if applied {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Applied")
                } else {
                    Text("Apply now")
                    Image(systemName: "arrow.right")
                }
            }
            .font(.system(size: 17.5, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(applied ? Color(.success) : Color(.accent), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 19, weight: .bold))
            .foregroundStyle(Color(.textPrimary))
            .padding(.top, 26)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func shareText(_ job: Job) -> String {
        "\(job.title) at \(job.company.name) — \(job.salary.formatted) · \(job.location)"
    }
}

#Preview {
    NavigationStack {
        JobDetailView(jobID: "rr-1024")
    }
}
