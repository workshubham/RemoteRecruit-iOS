//
//  RRChip.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

struct RRChip: View {
    
    enum Tone {
        case neutral
        case accent
    }

    let text: String
    var systemImage: String?
    var tone: Tone = .neutral

    init(_ text: String, systemImage: String? = nil, tone: Tone = .neutral) {
        self.text = text
        self.systemImage = systemImage
        self.tone = tone
    }

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(text)
        }
        .font(.system(size: 12.5, weight: .semibold))
        .foregroundStyle(tone == .accent ? Color(.accentText) : Color(.chipText))
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(tone == .accent ? Color(.accentSoft) : Color(.chipBackground), in: Capsule())
    }
}

#Preview {
    HStack(spacing: 8) {
        RRChip("Remote")
        RRChip("Full-time", systemImage: "briefcase")
        RRChip("Senior", tone: .accent)
    }
    .padding()
}
