//
//  SkeletonCard.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 13) {
                bar(width: 50, height: 50, radius: 14)
                VStack(alignment: .leading, spacing: 9) {
                    bar(width: 160, height: 15)
                    bar(width: 100, height: 12)
                }
                Spacer()
            }
            HStack(spacing: 8) {
                bar(width: 90, height: 22, radius: 999)
                bar(width: 64, height: 22, radius: 999)
            }
            .padding(.top, 16)
        }
        .padding(16)
        .background(Color(.surface), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
        .shimmering()
    }

    private func bar(width: CGFloat, height: CGFloat, radius: CGFloat = 6) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color(.skeleton))
            .frame(width: width, height: height)
    }
}

struct SkeletonList: View {
    var count = 6

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<count, id: \.self) { _ in
                SkeletonCard()
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SkeletonList()
        .background(Color(.background))
}
