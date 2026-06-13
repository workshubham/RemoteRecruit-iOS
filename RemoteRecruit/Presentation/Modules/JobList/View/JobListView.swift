//
//  JobListView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct JobListView: View {
    @State private var viewModel = JobListViewModel()
    @State private var showSearch = false
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    brandHeader
                    
                    switch viewModel.state {
                        case .loading:
                            SkeletonList()
                                .padding(.top, 8)
                        case .error(let message):
                            errorView(message)
                        case .empty:
                            emptyView
                        case .loaded:
                            loadedSection
                    }
                }
            }
            .background(Color(.background))
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    headerView
                        .padding(8)
                        .fixedSize()
                }
            }
            .toolbarBackground(Color(.background), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .refreshable { await viewModel.loadFirstPage() }
            .jobNavigationDestinations(in: namespace)
            .fullScreenCover(isPresented: $showSearch) {
                SearchView()
            }
        }
        .task { await viewModel.onAppear() }
    }
    
    private var headerView: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.accent))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                )
            HStack(spacing: 0) {
                Text("Remote").foregroundStyle(Color(.textPrimary))
                Text("Recruit").foregroundStyle(Color(.accentText))
            }
            .font(.system(size: 16, weight: .bold))
        }
    }
    
    // MARK: - Sections
    
    private var loadedSection: some View {
        Section {
            VStack(spacing: 12) {
                ForEach(viewModel.jobs) { job in
                    NavigationLink(value: JobDestination.detail(jobID: job.id)) {
                        JobCardView(job: job)
                    }
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: job.id, in: namespace)
                    .task {
                        if job.id == viewModel.jobs.last?.id {
                            await viewModel.loadNextPage()
                        }
                    }
                }
                
                if viewModel.isLoadingNextPage {
                    ProgressView().padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        } header: {
            ListSectionHeader(sort: $viewModel.sort) { showSearch = true }
        }
    }
    
    private var brandHeader: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Find your next role")
                .font(.system(size: 32, weight: .heavy))
                .lineLimit(2)
                .foregroundStyle(Color(.textPrimary))

            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(Color(.textSecondary))
                .padding(.top, 10)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var subtitle: String {
        if case .loaded = viewModel.state {
            return "\(viewModel.jobs.count) roles open right now"
        }
        return "Curated remote-first engineering jobs"
    }
    
    private var emptyView: some View {
        StatusView(
            icon: "tray",
            title: "No jobs posted yet",
            message: "There are no open roles right now. Pull to refresh or check back later.",
            actionTitle: "Refresh",
            action: { Task { await viewModel.retry() } }
        )
        .frame(minHeight: 360)
    }
    
    private func errorView(_ message: String) -> some View {
        StatusView(
            icon: "wifi.slash",
            iconColor: .orange,
            title: "Couldn't load jobs",
            message: message,
            actionTitle: "Try Again",
            action: { Task { await viewModel.retry() } }
        )
        .frame(minHeight: 360)
    }
}

#Preview {
    JobListView()
}
