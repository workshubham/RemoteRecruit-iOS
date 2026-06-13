//
//  CompanyLogoView.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct CompanyLogoView: View {
    let companyName: String
    let brandColorHex: String
    var size: CGFloat = 50
    var radius: CGFloat = 14

    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color(hex: brandColorHex))
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(.system(size: size * 0.38, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.5)
            )
    }

    private var initials: String {
        let parts = companyName
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty }
        guard let first = parts.first else { return "?" }
        if parts.count == 1 {
            return String(first.prefix(2)).uppercased()
        }
        let second = parts[1]
        return (first.prefix(1) + second.prefix(1)).uppercased()
    }
}

#Preview {
    CompanyLogoView(companyName: "Lumen Health", brandColorHex: "#6EB5E3")
}
