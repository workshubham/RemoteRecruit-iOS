//
//  StatusView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct StatusView: View {
    
    let icon: String
    var iconColor: Color = Color(.textTertiary)
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(.surface))
                .frame(width: 84, height: 84)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 34, weight: .regular))
                        .foregroundStyle(iconColor)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                .padding(.bottom, 22)

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(.textPrimary))

            Text(message)
                .font(.system(size: 15))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .frame(maxWidth: 280)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 26)
                        .frame(height: 46)
                        .background(Color(.accent), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview("Empty") {
    StatusView(
        icon: "tray",
        title: "No jobs posted yet",
        message: "There are no open roles right now. Pull to refresh or check back later.",
        actionTitle: "Refresh",
        action: {}
    )
}

#Preview("Error") {
    StatusView(
        icon: "wifi.slash",
        iconColor: .orange,
        title: "Couldn't load jobs",
        message: "We hit a network error reaching the server. Check your connection and try again.",
        actionTitle: "Try Again",
        action: {}
    )
}
