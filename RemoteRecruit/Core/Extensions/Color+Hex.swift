//
//  Color+Hex.swift
//  RemoteRecruit
//
//  Created by Shubham Arora on 13/06/26.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else {
            self = .clear
            return
        }
        let r, g, b, a: Double
        switch cleaned.count {
            case 8:
                r = Double((value & 0xFF00_0000) >> 24) / 255
                g = Double((value & 0x00FF_0000) >> 16) / 255
                b = Double((value & 0x0000_FF00) >> 8) / 255
                a = Double(value & 0x0000_00FF) / 255
            default:
                r = Double((value & 0xFF0000) >> 16) / 255
                g = Double((value & 0x00FF00) >> 8) / 255
                b = Double(value & 0x0000FF) / 255
                a = 1
        }
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
