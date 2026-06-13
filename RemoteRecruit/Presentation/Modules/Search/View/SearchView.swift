//
//  SearchView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SearchViewModel()
    @FocusState private var fieldFocused: Bool
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                content
            }
            .background(Color(.background))
            .toolbar(.hidden, for: .navigationBar)
            .jobNavigationDestinations(in: namespace)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(150))
            fieldFocused = true
        }
    }
    
    // MARK: - Search bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color(.textTertiary))
                TextField("Title or company", text: $viewModel.query)
                    .focused($fieldFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                    .foregroundStyle(Color(.textPrimary))
                    .onChange(of: viewModel.query) { viewModel.queryChanged() }
                if !viewModel.query.isEmpty {
                    Button {
                        viewModel.query = ""
                        viewModel.queryChanged()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(.textTertiary))
                    }
                }
            }
            .font(.system(size: 16.5))
            .padding(.horizontal, 12)
            .frame(height: 46)
            .background(Color(.chipBackground), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
            
            Button("Cancel") { dismiss() }
                .font(.system(size: 16.5))
                .foregroundStyle(Color(.accentText))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            case .idle:
                suggestions
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .results:
                resultsList
            case .empty:
                StatusView(
                    icon: "magnifyingglass",
                    title: "No matches for “\(viewModel.query)”",
                    message: "Try a different job title or company name — for example “iOS” or “Lumen”."
                )
            case .error(let message):
                StatusView(
                    icon: "wifi.slash",
                    iconColor: .orange,
                    title: "Couldn't search",
                    message: message
                )
        }
    }
    
    private var suggestions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SUGGESTED")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(.textSecondary))
                .padding(.top, 6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach(viewModel.suggestions, id: \.self) { suggestion in
                        Button {
                            viewModel.query = suggestion
                            viewModel.queryChanged()
                        } label: {
                            Text(suggestion)
                                .font(.system(size: 14.5, weight: .semibold))
                                .foregroundStyle(Color(.textPrimary))
                                .padding(.horizontal, 15)
                                .frame(height: 36)
                                .background(Color(.surface), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var resultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("\(viewModel.results.count) result\(viewModel.results.count == 1 ? "" : "s") for “\(viewModel.query)”")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                VStack(spacing: 12) {
                    ForEach(viewModel.results) { job in
                        NavigationLink(value: JobDestination.detail(jobID: job.id)) {
                            JobCardView(job: job)
                        }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: job.id, in: namespace)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    SearchView()
}
