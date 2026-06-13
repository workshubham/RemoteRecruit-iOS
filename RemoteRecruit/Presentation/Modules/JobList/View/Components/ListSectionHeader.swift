//
//  ListSectionHeader.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct ListSectionHeader: View {
    @Binding var sort: JobSort
    var onSearch: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onSearch) {
                HStack(spacing: 9) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color(.textTertiary))
                    Text("Search by title or company")
                        .foregroundStyle(Color(.textSecondary))
                    Spacer()
                }
                .font(.system(size: 16))
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(Color(.chipBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)

            HStack(alignment: .firstTextBaseline) {
                Text("Latest jobs")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(.textPrimary))

                Spacer()

                Menu {
                    Picker("Sort", selection: $sort) {
                        ForEach(JobSort.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                } label: {
                    HStack(spacing: 3) {
                        Text("Sort: \(sort.displayName)")
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.accentText))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(Color(.background))
    }
}

#Preview {
    ListSectionHeader(sort: .constant(.newest), onSearch: {})
}
